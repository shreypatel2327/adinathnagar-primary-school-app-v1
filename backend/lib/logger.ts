import { db } from "@/lib/db";

export async function logAction(userId: string, actionType: string, title: string, description: string) {
    try {
        // Ensure userId is valid, or handle system logs where userId might be special
        if (!userId) return;

        await db.systemLog.create({
            data: {
                userId,
                actionType,
                title,
                description,
            },
        });
    } catch (error) {
        console.error("Failed to create log:", error);
    }
}
