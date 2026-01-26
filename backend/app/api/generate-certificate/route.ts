
import { NextRequest, NextResponse } from "next/server";
import puppeteer from "puppeteer";

export const dynamic = 'force-dynamic';
import { getBonafideHtml, getValiFormHtml } from "../../../lib/certificate-generator";

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

        // Launch Puppeteer
        // Note: In production (e.g. Vercel), this might need ‘puppeteer-core’ + ‘chrome-aws-lambda’.
        // For local/VPS (Node.js), standard puppeteer works.
        const browser = await puppeteer.launch({
            headless: true,
            args: ["--no-sandbox", "--disable-setuid-sandbox"],
        });

        const page = await browser.newPage();

        // Set content and wait for fonts to load
        await page.setContent(htmlContent, {
            waitUntil: "networkidle0", // Wait for Google Fonts
        });

        // Generate PDF
        const pdfBuffer = await page.pdf({
            format: "A4",
            printBackground: true,
            margin: { top: "0mm", right: "0mm", bottom: "0mm", left: "0mm" }, // Margins handled in CSS
        });

        await browser.close();

        // Return PDF
        return new NextResponse(pdfBuffer as any, {
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
