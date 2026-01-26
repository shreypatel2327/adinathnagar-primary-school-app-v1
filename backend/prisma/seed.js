import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {

    // OPTIONAL: clear existing students
    // await prisma.student.deleteMany();

    await prisma.student.createMany({
        data: [
            /* 👇 Student 1 object here */
            {
                grNo: 1001,
                firstName: "હર્ષિલ",
                middleName: "રવિન્દ્રભાઈ",
                lastName: "પટેલ",
                fullName: "પટેલ હર્ષિલ રવિન્દ્રભાઈ",
                gender: "કુમાર",
                dob: new Date("2014-07-18"),
                standard: 5,
                category: "OBC",
                address: "રામનગર, નરોડા, અમદાવાદ",

                oldSchoolGrNo: "4521",
                newSchoolGrNo: "7893",
                dietNo: "DIET-GJ-0001",
                prevSchool: "શ્રી સરસ્વતી પ્રાથમિક શાળા",

                mobile: "9898123456",
                birthPlace: "અમદાવાદ",
                caste: "OBC",

                fatherName: "રવિન્દ્રભાઈ પટેલ",
                fatherEdu: "ધોરણ 10",
                fatherOcc: "ખેતી",
                fatherAadhaar: "987654321098",
                fatherNameOnAadhaar: "RAVINDRABHAI PATEL",

                motherName: "સોનલબેન પટેલ",
                motherEdu: "ધોરણ 8",
                motherOcc: "ગૃહિણી",
                motherAadhaar: "123456789012",

                aadhaarNo: "456789123456",
                nameOnAadhaar: "HARSHIL PATEL",
                uid: "DISE-GJ-2024-0001",
                rationCard: "RC-GJ-458796",
                birthCertName: "HARSHIL RAVINDRABHAI PATEL",
                birthCertNo: "BC-2014-45879",

                bankAccount: "456712345678",
                ifscCode: "SBIN0001234",
                bankName: "State Bank of India",
                bankHolderName: "HARSHIL PATEL",

                admissionDate: new Date("2019-06-12"),
                academicYear: "2024-25",
                result: "પાસ",
                percentage: 76.5,
                attendance: 198,

                transportation: "હા",
                isHandicapped: "ના",
                handicapPercentage: null,

                status: "Active"
            },
            /* 👇 Student 2 object here */
            {
                grNo: 1002,
                firstName: "આરવ",
                middleName: "નિલેશભાઈ",
                lastName: "શાહ",
                fullName: "શાહ આરવ નિલેશભાઈ",
                gender: "કુમાર",
                dob: new Date("2019-11-05"),
                standard: 0,
                category: "GENERAL",
                address: "ઘાટલોડિયા, અમદાવાદ",

                oldSchoolGrNo: null,
                newSchoolGrNo: null,
                dietNo: null,
                prevSchool: null,

                mobile: "9876501234",
                birthPlace: "અમદાવાદ",
                caste: "GENERAL",

                fatherName: "નિલેશભાઈ શાહ",
                fatherEdu: "સ્નાતક",
                fatherOcc: "વ્યવસાય",
                fatherAadhaar: "998877665544",
                fatherNameOnAadhaar: "NILESH SHAH",

                motherName: "રીટાબેન શાહ",
                motherEdu: "ધોરણ 12",
                motherOcc: "ગૃહિણી",
                motherAadhaar: "887766554433",

                aadhaarNo: "123456789012",
                nameOnAadhaar: "AARAV SHAH",
                uid: "DISE-GJ-2024-0002",
                rationCard: "RC-GJ-987654",
                birthCertName: "AARAV NILESH SHAH",
                birthCertNo: "BC-2019-99887",

                bankAccount: null,
                ifscCode: null,
                bankName: null,
                bankHolderName: null,

                admissionDate: new Date("2024-06-10"),
                academicYear: "2024-25",
                result: "પાસ",
                percentage: null,
                attendance: 120,

                transportation: "ના",
                isHandicapped: "ના",
                handicapPercentage: null,

                status: "Active"
            },
            /* 👇 Student 3 object here */
            {
                grNo: 1003,
                firstName: "પ્રિયાંશી",
                middleName: "મહેશભાઈ",
                lastName: "વાઘેલા",
                fullName: "વાઘેલા પ્રિયાંશી મહેશભાઈ",
                gender: "કન્યા",
                dob: new Date("2011-02-22"),
                standard: 8,
                category: "SC",
                address: "સેક્ટર 21, ગાંધીનગર",

                oldSchoolGrNo: "3345",
                newSchoolGrNo: "9981",
                dietNo: "DIET-GJ-0003",
                prevSchool: "નવજીવન વિદ્યાલય",

                mobile: "9825098765",
                birthPlace: "ગાંધીનગર",
                caste: "SC",

                fatherName: "મહેશભાઈ વાઘેલા",
                fatherEdu: "ધોરણ 7",
                fatherOcc: "મજૂરી",
                fatherAadhaar: "112233445566",
                fatherNameOnAadhaar: "MAHESHBHAI VAGHELA",

                motherName: "કમલાબેન વાઘેલા",
                motherEdu: "અશિક્ષિત",
                motherOcc: "ગૃહિણી",
                motherAadhaar: "665544332211",

                aadhaarNo: "789456123098",
                nameOnAadhaar: "PRIYANSHI VAGHELA",
                uid: "DISE-GJ-2024-0003",
                rationCard: "RC-GJ-334455",
                birthCertName: "PRIYANSHI MAHESHBHAI VAGHELA",
                birthCertNo: "BC-2011-33445",

                bankAccount: "998877665544",
                ifscCode: "BKID0004567",
                bankName: "Bank of India",
                bankHolderName: "PRIYANSHI VAGHELA",

                admissionDate: new Date("2017-06-15"),
                academicYear: "2024-25",
                result: "પાસ",
                percentage: 61.2,
                attendance: 185,

                transportation: "હા",
                isHandicapped: "હા",
                handicapPercentage: 40,

                status: "Active"
            }

        ]
    });

    console.log("✅ Students seeded successfully");
}

main()
    .catch(console.error)
    .finally(() => prisma.$disconnect());
