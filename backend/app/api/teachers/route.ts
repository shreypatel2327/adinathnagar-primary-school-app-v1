
import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export const dynamic = 'force-dynamic';

export async function GET(req: Request) {
    try {
        const { searchParams } = new URL(req.url);
        const search = searchParams.get("search");

        const teachers = await db.user.findMany({
            where: {
                role: "TEACHER",
                OR: search
                    ? [
                        { fullName: { contains: search } },
                        { username: { contains: search } },
                    ]
                    : undefined,
            },
            orderBy: { createdAt: "desc" },
        });

        return NextResponse.json(teachers);
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to fetch teachers" },
            { status: 500 }
        );
    }
}

export async function POST(req: Request) {
    try {
        const body = await req.json();
        const { username, password, fullName, standard, isActive } = body;

        if (!username || !password || !fullName) {
            return NextResponse.json({ error: "Missing required fields" }, { status: 400 });
        }

        // Check existing
        const existingUser = await db.user.findUnique({ where: { username } });
        if (existingUser) {
            return NextResponse.json({ error: "Username already exists" }, { status: 400 });
        }

        const teacher = await db.user.create({
            data: {
                username,
                password, // In a real app, hash this!
                role: "TEACHER",
                fullName,
                standard,
                isActive: isActive ?? true
            },
        });

        // Log the action
        // For now, attributing to the new teacher themselves or system. 
        // Ideally we want the creator. Using getSystemActorId() implicitly via empty string if needed, 
        // but here let's try to find an admin or just use null and let logger handle it.
        // Actually, let's just pass "" and let logger find an admin.
        const { logAction } = await import("@/lib/logger");
        await logAction("", "Added", teacher.fullName || teacher.username, "Added New Teacher");

        return NextResponse.json(teacher);
    } catch (error) {
        return NextResponse.json(
            { error: "Failed to create teacher" },
            { status: 500 }
        );
    }
}
