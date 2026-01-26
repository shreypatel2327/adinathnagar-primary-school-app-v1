"use server";

import { db } from "@/lib/db";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

export async function createStudent(formData: FormData) {
    const fullName = formData.get("fullName") as string;
    const dob = formData.get("dob") as string;
    const standard = formData.get("standard") as string;
    const gender = formData.get("gender") as string;

    const fatherName = formData.get("fatherName") as string;
    const motherName = formData.get("motherName") as string;
    const category = formData.get("category") as string;
    const address = formData.get("address") as string;

    const aadhaarNo = formData.get("aadhaarNo") as string;
    const bankAccount = formData.get("bankAccount") as string;
    const ifscCode = formData.get("ifscCode") as string;

    // Simple validation or splitting logic if needed
    // For now, storing as provided

    await db.student.create({
        data: {
            firstName: fullName.split(" ")[0] || fullName, // Fallback
            lastName: fullName.split(" ").slice(1).join(" ") || "",
            fullName: fullName,
            dob: dob ? new Date(dob) : undefined,
            standard: parseInt(standard) || 0,
            gender: gender,

            fatherName,
            motherName,
            category,
            address,

            aadhaarNo,
            bankAccount,
            ifscCode,
        },
    });

    revalidatePath("/admin/students");
    redirect("/admin/students");
}
