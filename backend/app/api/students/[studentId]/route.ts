import { db } from "@/lib/db";
import { NextResponse } from "next/server";
import { z } from "zod";

// --- REUSED SCHEMA FROM POST ROUTE ---
const studentSchema = z.object({
    standard: z.coerce.number().min(0, "Standard is required"),
    oldSchoolGrNo: z.string().nullable().optional(),
    newSchoolGrNo: z.string().nullable().optional(),
    fullName: z.string().min(1, "Full name is required"),
    firstName: z.string().optional(),
    dob: z.string().min(1, "Date of Birth is required"),
    birthPlace: z.string().min(1, "Birth place is required"),
    gender: z.enum(["Boy", "Girl"]),
    caste: z.string().min(1, "Caste is required"),
    address: z.string().min(1, "Address is required"),
    mobile: z.string().regex(/^\d{10}$/, "Mobile must be 10 digits"),
    fatherName: z.string().min(1, "Father Name is required"),
    fatherEdu: z.string().min(1, "Father Education is required"),
    fatherOcc: z.string().min(1, "Father Occupation is required"),
    motherName: z.string().min(1, "Mother Name is required"),
    motherEdu: z.string().min(1, "Mother Education is required"),
    motherOcc: z.string().min(1, "Mother Occupation is required"),
    uid: z.string().min(1, "UID is required"),
    aadhaarNo: z.string().regex(/^\d{12}$/, "Aadhaar must be 12 digits"),
    nameOnAadhaar: z.string().min(1, "Name on Aadhaar is required"),
    rationCard: z.string().optional(),
    bankAccount: z.string().min(1, "Bank Account is required"),
    ifscCode: z.string().min(1, "IFSC Code is required"),
    bankName: z.string().min(1, "Bank Name is required"),
    bankHolderName: z.string().min(1, "Bank Holder Name is required"),
    admissionDate: z.string().min(1, "Admission Date is required"),
    transportation: z.string().optional(),
    isHandicapped: z.string().optional(),

    // Allow updating other fields too if needed
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
    handicapPercentage: z.string().nullable().optional(),
    category: z.string().nullable().optional(),
});

export async function GET(req: Request, { params }: { params: { studentId: string } }) {
    try {
        const student = await db.student.findUnique({
            where: { id: params.studentId }
        });
        if (!student) {
            return NextResponse.json({ error: "Student not found" }, { status: 404 });
        }
        return NextResponse.json(student);
    } catch (error) {
        return NextResponse.json({ error: "Failed to fetch student" }, { status: 500 });
    }
}

export async function PUT(req: Request, { params }: { params: { studentId: string } }) {
    try {
        const body = await req.json();
        const validation = studentSchema.safeParse(body);
        if (!validation.success) {
            return NextResponse.json(
                { error: "Validation Failed", details: validation.error.format() },
                { status: 400 }
            );
        }

        // Prepare data similar to POST but without GR No generation
        const student = await db.student.update({
            where: { id: params.studentId },
            data: {
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
                category: body.caste,
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
        return NextResponse.json(student);
    } catch (error) {
        console.error("Update Student Error:", error);
        return NextResponse.json({ error: "Failed to update student" }, { status: 500 });
    }
}

export async function DELETE(req: Request, { params }: { params: { studentId: string } }) {
    try {
        await db.student.delete({
            where: { id: params.studentId },
        });
        return NextResponse.json({ message: "Student deleted" });
    } catch (error) {
        return NextResponse.json({ error: "Failed to delete student" }, { status: 500 });
    }
}
