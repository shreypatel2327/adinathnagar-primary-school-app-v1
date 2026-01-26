
import { NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/db"; // Use shared db instance

export async function PATCH(
    request: NextRequest,
    { params }: { params: { studentId: string } } // Changed from id to studentId
) {
    try {
        const id = params.studentId;
        const body = await request.json();
        const { leavingDate, destinationSchool, remarks } = body;

        // Validation
        if (!leavingDate || !destinationSchool) {
            return NextResponse.json(
                { error: "Leaving Date and Destination School are mandatory" },
                { status: 400 }
            );
        }

        const updatedStudent = await db.student.update({
            where: { id },
            data: {
                status: "Javak",
                leavingDate: new Date(leavingDate),
                destinationSchool,
                remarks: remarks || "",
            },
        });

        // Audit Log
        try {
            await db.systemLog.create({
                data: {
                    action: "JAVAK_MARKED",
                    details: `Student ${updatedStudent.firstName} ${updatedStudent.lastName} (GR: ${updatedStudent.grNo}) marked as Javak. Dest: ${destinationSchool}`,
                }
            });
        } catch (e) {
            console.warn("Failed to create audit log", e);
        }

        return NextResponse.json(updatedStudent);
    } catch (error) {
        console.error("Error marking student as Javak:", error);
        return NextResponse.json(
            { error: "Failed to update student status" },
            { status: 500 }
        );
    }
}
