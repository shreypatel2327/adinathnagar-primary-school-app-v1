
import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export const dynamic = 'force-dynamic';

export async function GET() {
    try {
        const students = await db.student.findMany({
            where: {
                status: "Javak",
            },
            orderBy: {
                leavingDate: "desc", // Most recently left first
            },
        });
        return NextResponse.json(students);
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to fetch Javak register" },
            { status: 500 }
        );
    }
}
