import { NextRequest, NextResponse } from "next/server";
import { getBonafideHtml, getValiFormHtml } from "../../../lib/certificate-generator";
import path from 'path';
import fs from 'fs';
import os from 'os';

export const dynamic = 'force-dynamic';
export const maxDuration = 60;

export async function OPTIONS() {
    return NextResponse.json({}, { status: 200 });
}

function getLocalChromePath(): string | undefined {
    // ... [Same helper as before] ...
    const platform = os.platform();
    let possiblePaths: string[] = [];
    if (platform === 'win32') {
        possiblePaths = [
            "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
            "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe",
            process.env.LOCALAPPDATA + "\\Google\\Chrome\\Application\\chrome.exe",
            "C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe",
        ];
    } else if (platform === 'darwin') {
        possiblePaths = [
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        ];
    } else {
        possiblePaths = ["/usr/bin/google-chrome", "/usr/bin/chromium"];
    }
    return possiblePaths.find(p => p && fs.existsSync(p));
}

export async function POST(req: NextRequest) {
    try {
        const body = await req.json();
        const { certificateType, studentData } = body;

        let htmlContent = "";
        if (certificateType === "bonafide") htmlContent = getBonafideHtml(studentData);
        else if (certificateType === "vali-form") htmlContent = getValiFormHtml(studentData);
        else return NextResponse.json({ error: "Invalid certificateType" }, { status: 400 });

        let browser;
        let page;

        try {
            const isProduction = process.env.VERCEL_ENV === "production" || process.env.NODE_ENV === "production";
            const puppeteer = require("puppeteer-core");

            let executablePath: string | undefined;
            let launchArgs: string[] = [];
            let headlessMode: boolean | "shell" = true;

            if (isProduction) {
                // Configure Chromium for Vercel with Min Pack
                const chromium = require("@sparticuz/chromium-min");

                // IMPORTANT: Provide the remote pack URL for the binary
                // Using the specific version matching package.json (v131.0.1)
                // chromium.setRemotePack("..."); // REMOVED - Invalid API

                chromium.setGraphicsMode = false;

                // Pass the pack URL directly to executablePath
                executablePath = await chromium.executablePath("https://github.com/Sparticuz/chromium/releases/download/v131.0.1/chromium-v131.0.1-pack.tar");
                launchArgs = chromium.args;
                headlessMode = chromium.headless;
            } else {
                executablePath = getLocalChromePath();
                if (!executablePath) throw new Error("Local Chrome not found");
                launchArgs = ["--no-sandbox", "--disable-setuid-sandbox"];
            }

            console.log(`Launching browser: ${executablePath}`);

            browser = await puppeteer.launch({
                args: launchArgs,
                defaultViewport: { width: 794, height: 1123 },
                executablePath: executablePath,
                headless: headlessMode,
                ignoreHTTPSErrors: true,
            });

            page = await browser.newPage();
            await page.setContent(htmlContent, { waitUntil: "networkidle0" });
            const pdfBuffer = await page.pdf({ format: "A4", printBackground: true });

            await browser.close();

            return new NextResponse(pdfBuffer, {
                headers: {
                    "Content-Type": "application/pdf",
                    "Content-Disposition": `inline; filename="${certificateType}.pdf"`,
                },
            });

        } catch (innerError) {
            console.error("Browser Launch Error:", innerError);
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
