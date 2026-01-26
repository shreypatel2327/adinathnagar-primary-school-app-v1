
import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export const dynamic = 'force-dynamic';

export async function GET() {
    try {
        const students = await db.student.findMany({
            where: {
                status: "Active", // Filter for currently studying
            },
            orderBy: {
                grNo: "desc", // Newest GR first
            },
        });
        return NextResponse.json(students);
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to fetch Aavak register" },
            { status: 500 }
        );
    }
}
