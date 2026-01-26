
import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET() {
    try {
        const totalStudents = await db.student.count({
            where: { status: "Active" },
        });

        const javakCount = await db.student.count({
            where: { status: "Javak" },
        });

        // "Aavak" (Arrival) Register typically contains all admitted students who are currently active.
        // To match the "Aavak Register" list count, we count all Active students.
        const aavakCount = await db.student.count({
            where: {
                status: "Active",
            }
        });

        return NextResponse.json({
            totalStudents,
            javakCount,
            aavakCount,
            standardCount: "1-8" // Static for now
        });
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to fetch dashboard stats" },
            { status: 500 }
        );
    }
}
