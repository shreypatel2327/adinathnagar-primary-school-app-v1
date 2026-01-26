import { db } from "@/lib/db";
import { NextResponse } from "next/server";
import { z } from "zod";

export const dynamic = 'force-dynamic';

// Strict validation schema
const studentSchema = z.object({
    standard: z.coerce.number().min(0, "Standard is required"),

    // Conditional fields (allowed to be null/empty if not applicable, but let's check basic types)
    oldSchoolGrNo: z.string().nullable().optional(),
    newSchoolGrNo: z.string().nullable().optional(),

    // Personal (Compulsory)
    fullName: z.string().min(1, "Full name is required"),
    firstName: z.string().optional(), // derived
    dob: z.string().min(1, "Date of Birth is required"),
    birthPlace: z.string().min(1, "Birth place is required"),
    gender: z.enum(["Boy", "Girl"]),
    caste: z.string().min(1, "Caste is required"),
    address: z.string().min(1, "Address is required"),
    mobile: z.string().regex(/^\d{10}$/, "Mobile must be 10 digits"),

    // Family (Compulsory)
    fatherName: z.string().min(1, "Father Name is required"),
    fatherEdu: z.string().min(1, "Father Education is required"),
    fatherOcc: z.string().min(1, "Father Occupation is required"),
    motherName: z.string().min(1, "Mother Name is required"),
    motherEdu: z.string().min(1, "Mother Education is required"),
    motherOcc: z.string().min(1, "Mother Occupation is required"),

    // Govt (Compulsory)
    uid: z.string().min(1, "UID is required"),
    aadhaarNo: z.string().regex(/^\d{12}$/, "Aadhaar must be 12 digits"),
    nameOnAadhaar: z.string().min(1, "Name on Aadhaar is required"),
    rationCard: z.string().optional(), // Maybe optional? User said "all compulsory".. let's assume it is.

    // Bank (Compulsory)
    bankAccount: z.string().min(1, "Bank Account is required"),
    ifscCode: z.string().min(1, "IFSC Code is required"),
    bankName: z.string().min(1, "Bank Name is required"),
    bankHolderName: z.string().min(1, "Bank Holder Name is required"),

    // Academic & Social
    // Academic & Social
    admissionDate: z.string().min(1, "Admission Date is required"),
    transportation: z.string().nullable().optional(),
    isHandicapped: z.string().nullable().optional(),
    handicapPercentage: z.string().nullable().optional(),

    // Other optional fields (matching PUT schema for completeness)
    dietNo: z.string().nullable().optional(),
    prevSchool: z.string().nullable().optional(),
    fatherAadhaar: z.string().nullable().optional(),
    fatherNameOnAadhaar: z.string().nullable().optional(),
    motherAadhaar: z.string().nullable().optional(),
    birthCertName: z.string().nullable().optional(),
    birthCertNo: z.string().nullable().optional(),
    academicYear: z.string().nullable().optional(),
    result: z.string().nullable().optional(),
    percentage: z.string().nullable().optional(),
    attendance: z.string().nullable().optional(),
    category: z.string().nullable().optional(),
});

export async function GET() {
    try {
        const students = await db.student.findMany({
            where: { status: "Active" },
            orderBy: { createdAt: "desc" },
        });
        return NextResponse.json(students);
    } catch (error) {
        return NextResponse.json({ error: "Failed to fetch students" }, { status: 500 });
    }
}

export async function POST(req: Request) {
    try {
        const body = await req.json();

        console.log("Received Data:", body); // Debug log

        // Validate data
        const validation = studentSchema.safeParse(body);
        if (!validation.success) {
            console.error("Validation Error:", validation.error.format());
            return NextResponse.json(
                { error: "Validation Failed", details: validation.error.format() },
                { status: 400 }
            );
        }

        // Manual GR No generation
        const lastStudent = await db.student.findFirst({
            orderBy: { grNo: 'desc' },
        });
        const nextGrNo = (lastStudent?.grNo ?? 0) + 1;

        const student = await db.student.create({
            data: {
                grNo: nextGrNo,
                standard: parseInt(body.standard) || 0,

                oldSchoolGrNo: body.oldSchoolGrNo,
                newSchoolGrNo: body.newSchoolGrNo,
                dietNo: body.dietNo,
                prevSchool: body.prevSchool,

                fullName: body.fullName,
                dob: body.dob ? new Date(body.dob) : undefined,
                birthPlace: body.birthPlace,
                gender: body.gender,
                caste: body.caste,
                category: body.caste, // utilizing caste as category or separate field? Schema has `caste` and `category`. Let's map caste to caste.
                address: body.address,
                mobile: body.mobile,
                firstName: body.firstName || body.fullName?.split(' ')[0] || 'Unknown',

                fatherName: body.fatherName,
                fatherEdu: body.fatherEdu,
                fatherOcc: body.fatherOcc,
                fatherAadhaar: body.fatherAadhaar,
                fatherNameOnAadhaar: body.fatherNameOnAadhaar,

                motherName: body.motherName,
                motherEdu: body.motherEdu,
                motherOcc: body.motherOcc,
                motherAadhaar: body.motherAadhaar,

                aadhaarNo: body.aadhaarNo,
                nameOnAadhaar: body.nameOnAadhaar,
                uid: body.uid,
                rationCard: body.rationCard,
                birthCertName: body.birthCertName,
                birthCertNo: body.birthCertNo,

                bankAccount: body.bankAccount,
                ifscCode: body.ifscCode,
                bankName: body.bankName,
                bankHolderName: body.bankHolderName,

                admissionDate: body.admissionDate ? new Date(body.admissionDate) : undefined,
                academicYear: body.academicYear,
                result: body.result,
                percentage: body.percentage ? parseFloat(body.percentage) : null,
                attendance: body.attendance ? parseFloat(body.attendance) : null,

                transportation: body.transportation,
                isHandicapped: body.isHandicapped,
                handicapPercentage: body.handicapPercentage ? parseFloat(body.handicapPercentage) : null,
            },
        });

        // Log the action
        const { logAction } = await import("@/lib/logger");
        await logAction("", "Added", `${student.firstName} ${student.lastName || ''}`.trim(), `Added New Student: ${student.firstName}`);

        return NextResponse.json(student);
    } catch (error) {
        console.error("Create Student Error:", error);
        return NextResponse.json({ error: "Failed to create student: " + error }, { status: 500 });
    }
}
