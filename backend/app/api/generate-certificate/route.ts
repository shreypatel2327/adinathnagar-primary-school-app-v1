import { NextRequest, NextResponse } from "next/server";
import { getBonafideHtml, getValiFormHtml } from "../../../lib/certificate-generator";
import path from 'path';
import fs from 'fs';
import os from 'os';

export const dynamic = 'force-dynamic';
export const maxDuration = 60;

// Explicit OPTIONS for CORS preflight
export async function OPTIONS() {
    return NextResponse.json({}, { status: 200 });
}

// Function to find local Chrome path
function getLocalChromePath(): string | undefined {
    const platform = os.platform();
    let possiblePaths: string[] = [];

    if (platform === 'win32') {
        possiblePaths = [
            "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
            process.env.LOCALAPPDATA + "\\Google\\Chrome\\Application\\chrome.exe",
            "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
            "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
        ];
    } else if (platform === 'darwin') {
        possiblePaths = [
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
            "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
        ];
    } else {
        possiblePaths = [
            "/usr/bin/google-chrome",
            "/usr/bin/chromium",
            "/usr/bin/chromium-browser"
        ];
    }

    for (const p of possiblePaths) {
        if (p && fs.existsSync(p)) return p;
    }
    return undefined;
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
            // Check if running on Vercel
            const isProduction = process.env.VERCEL_ENV === "production" || process.env.NODE_ENV === "production";

            const puppeteer = require("puppeteer-core");
            let executablePath: string | undefined;
            let launchArgs: string[] = [];
            let headlessMode: boolean | "shell" = true;

            if (isProduction) {
                // Production (Vercel)
                const chromium = require("@sparticuz/chromium");

                // Configure Chromium for Vercel
                // chromium.setGraphicsMode = false; // Deprecated in newer versions, checking docs is key but standard flags help

                executablePath = await chromium.executablePath();

                // Aggressive flags for Vercel/Lambda environment
                launchArgs = [
                    ...chromium.args,
                    '--disable-gpu',
                    '--disable-dev-shm-usage',
                    '--disable-setuid-sandbox',
                    '--no-sandbox',
                    '--no-zygote',
                    '--single-process', // Sometimes helps in strict memory limits
                ];
                headlessMode = chromium.headless;
            } else {
                // Local Development
                executablePath = getLocalChromePath();
                if (!executablePath) {
                    throw new Error("Local Chrome/Edge executable not found. Please install Chrome or Edge.");
                }
                launchArgs = ["--no-sandbox", "--disable-setuid-sandbox"];
            }

            console.log(`Launching browser with executable: ${executablePath}`);

            browser = await puppeteer.launch({
                args: launchArgs,
                defaultViewport: { width: 794, height: 1123 }, // A4 Size in px
                executablePath: executablePath,
                headless: headlessMode,
                ignoreHTTPSErrors: true,
            });

            page = await browser.newPage();

            // Set content and STRICTLY wait for fonts to load
            await page.setContent(htmlContent, {
                waitUntil: "networkidle0",
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
