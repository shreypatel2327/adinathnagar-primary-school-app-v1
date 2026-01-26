import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export async function POST(req: Request) {
    try {
        const body = await req.json();
        const { username, password } = body;

        if (!username || !password) {
            return NextResponse.json({ error: "Missing credentials" }, { status: 400 });
        }

        const user = await db.user.findUnique({
            where: { username }
        });

        if (!user || user.password !== password) { // In production, use bcrypt.compare
            return NextResponse.json({ error: "Invalid credentials" }, { status: 401 });
        }

        if (!user.isActive) {
            return NextResponse.json({ error: "Account is inactive" }, { status: 403 });
        }

        // Return user info (excluding password)
        const { password: _, ...userWithoutPassword } = user;

        return NextResponse.json({
            user: userWithoutPassword,
            token: "mock-jwt-token" // In production, sign a real JWT
        });

    } catch (error) {
        console.error("Login API Error:", error);
        return NextResponse.json(
            { error: "Login failed", details: String(error) }, // Returning details for debugging
            { status: 500 }
        );
    }
}
