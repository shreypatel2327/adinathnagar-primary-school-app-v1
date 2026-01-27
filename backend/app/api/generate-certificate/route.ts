import { NextRequest, NextResponse } from "next/server";
import { getBonafideHtml, getValiFormHtml } from "../../../lib/certificate-generator";

export const dynamic = 'force-dynamic';
export const maxDuration = 60; // Set max duration for Vercel Function (if on Pro plan, otherwise 10s might be tight but PDF gen is usually fast enough).

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
        let page;

        try {
            if (process.env.VERCEL_ENV === "production" || process.env.NODE_ENV === "production") {
                // Production (Vercel)
                const chromium = require("@sparticuz/chromium");
                const puppeteer = require("puppeteer-core");

                // Configure Chromium for Vercel
                chromium.setGraphicsMode = false;
                chromium.setHeadlessMode = true;

                browser = await puppeteer.launch({
                    args: chromium.args,
                    defaultViewport: { width: 794, height: 1123 }, // A4 Size in px
                    executablePath: await chromium.executablePath(),
                    headless: chromium.headless,
                    ignoreHTTPSErrors: true,
                });
            } else {
                // Local Development
                // We utilize the 'puppeteer' package which includes the browser binary
                const puppeteer = require("puppeteer");

                // You can also specify an executablePath if you want to use a local Chrome
                // const { executablePath } = require('puppeteer'); 

                browser = await puppeteer.launch({
                    headless: true,
                    defaultViewport: { width: 794, height: 1123 }, // A4 Size in px
                    args: ["--no-sandbox", "--disable-setuid-sandbox"],
                });
            }

            page = await browser.newPage();

            // Set content and STRICTLY wait for fonts to load
            await page.setContent(htmlContent, {
                waitUntil: "networkidle0", // Wait for all network connections (fonts) to finish
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
        } catch (innerError) {
            console.error("Browser Launch/Page Error:", innerError);
            if (browser) await browser.close();
            throw innerError;
        }

    } catch (error) {
        console.error("PDF generation global error:", error);
        return NextResponse.json({
            error: "Failed to generate PDF",
            details: error instanceof Error ? error.message : String(error)
        }, { status: 500 });
    }
}
