
import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export async function PUT(
    req: Request,
    { params }: { params: { id: string } }
) {
    try {
        const body = await req.json();
        const { username, password, fullName, standard, isActive } = body;

        const teacher = await db.user.update({
            where: { id: params.id },
            data: {
                username,
                password,
                fullName,
                standard,
                isActive
            },
        });

        return NextResponse.json(teacher);
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to update teacher" },
            { status: 500 }
        );
    }
}

export async function DELETE(
    req: Request,
    { params }: { params: { id: string } }
) {
    try {
        await db.user.delete({
            where: { id: params.id },
        });

        return NextResponse.json({ message: "Teacher deleted" });
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to delete teacher" },
            { status: 500 }
        );
    }
}
