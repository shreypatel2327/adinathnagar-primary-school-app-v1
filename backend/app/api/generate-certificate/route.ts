import { NextRequest, NextResponse } from "next/server";
import { getBonafideHtml, getValiFormHtml } from "../../../lib/certificate-generator";

export const dynamic = 'force-dynamic';

// Explicit OPTIONS for CORS preflight
export async function OPTIONS() {
    return NextResponse.json({}, { status: 200 });
}

export async function POST(req: NextRequest) {
    try {
        const body = await req.json();
        const { certificateType, studentData } = body;

        if (!studentData) {
            return NextResponse.json({ error: "Missing studentData" }, { status: 400 });
        }

        let htmlContent = "";
        if (certificateType === "bonafide") {
            htmlContent = getBonafideHtml(studentData);
        } else if (certificateType === "vali-form") {
            htmlContent = getValiFormHtml(studentData);
        } else {
            return NextResponse.json({ error: "Invalid certificateType" }, { status: 400 });
        }

        let browser;

        if (process.env.VERCEL_ENV === "production" || process.env.NODE_ENV === "production") {
            // Production (Vercel)
            const chromium = require("@sparticuz/chromium");
            const puppeteer = require("puppeteer-core");

            // Optional: Load fonts if needed (Chromium on Lambda has few fonts)
            // await chromium.font('https://raw.githack.com/googlefonts/noto-fonts/main/hinted/ttf/NotoSans/NotoSans-Regular.ttf');

            browser = await puppeteer.launch({
                args: chromium.args,
                defaultViewport: chromium.defaultViewport,
                executablePath: await chromium.executablePath(),
                headless: chromium.headless,
                ignoreHTTPSErrors: true,
            });
        } else {
            // Local Development
            const puppeteer = require("puppeteer");
            browser = await puppeteer.launch({
                headless: true,
                args: ["--no-sandbox", "--disable-setuid-sandbox"],
            });
        }

        const page = await browser.newPage();

        // Set content and wait for fonts to load
        await page.setContent(htmlContent, {
            waitUntil: "networkidle0", // Wait for Google Fonts
        });

        // Generate PDF
        const pdfBuffer = await page.pdf({
            format: "A4",
            printBackground: true,
            margin: { top: "0mm", right: "0mm", bottom: "0mm", left: "0mm" },
        });

        await browser.close();

        // Return PDF
        return new NextResponse(pdfBuffer, {
            headers: {
                "Content-Type": "application/pdf",
                "Content-Disposition": `inline; filename="${certificateType}.pdf"`,
            },
        });

    } catch (error) {
        console.error("PDF generation error:", error);
        return NextResponse.json({ error: "Failed to generate PDF", details: String(error) }, { status: 500 });
    }
}
