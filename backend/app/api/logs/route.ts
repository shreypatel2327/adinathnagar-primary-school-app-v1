import { db } from "@/lib/db";
import { NextResponse } from "next/server";

export async function GET(req: Request) {
    try {
        const { searchParams } = new URL(req.url);
        const search = searchParams.get("search");
        const action = searchParams.get("action");
        const period = searchParams.get("period"); // Today, This Week, Month

        let dateFilter = {};
        const now = new Date();

        if (period === "Today" || period === "આજે") {
            const start = new Date();
            start.setHours(0, 0, 0, 0);
            dateFilter = { createdAt: { gte: start } };
        } else if (period === "This Week" || period === "આ અઠવાડિયે") {
            const start = new Date();
            start.setDate(now.getDate() - 7);
            dateFilter = { createdAt: { gte: start } };
        } else if (period === "Month" || period === "મહિનો") {
            const start = new Date();
            start.setMonth(now.getMonth() - 1);
            dateFilter = { createdAt: { gte: start } };
        }

        const logs = await db.systemLog.findMany({
            where: {
                AND: [
                    action ? { actionType: action } : {},
                    search ? {
                        OR: [
                            { user: { fullName: { contains: search } } },
                            { user: { username: { contains: search } } }
                        ]
                    } : {},
                    dateFilter
                ]
            },
            include: {
                user: {
                    select: { fullName: true, username: true, role: true }
                }
            },
            orderBy: { createdAt: "desc" },
        });

        return NextResponse.json(logs);
    } catch (error) {
        console.error("Logs Fetch Error:", error);
        return NextResponse.json({ error: "Failed to fetch logs" }, { status: 500 });
    }
}
