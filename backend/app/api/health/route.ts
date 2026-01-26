import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export const dynamic = 'force-dynamic';

export async function GET(req: Request) {
    try {
        // 1. Check Environment Variable (Masked)
        const dbUrl = process.env.DATABASE_URL;
        const maskedUrl = dbUrl ? dbUrl.substring(0, 15) + "..." : "UNDEFINED";

        // 2. Test Connection
        await db.$queryRaw`SELECT 1`;

        return NextResponse.json({
            status: "OK",
            database: "Connected",
            env_check: maskedUrl,
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error("Health Check Failed:", error);
        return NextResponse.json({
            status: "ERROR",
            database: "Disconnected",
            error: String(error),
            env_check: process.env.DATABASE_URL ? "Defined" : "MISSING"
        }, { status: 500 });
    }
}
