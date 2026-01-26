const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
    try {
        const username = 'admin';
        const password = 'admin'; // In a real app, hash this!
        
        const existingUser = await prisma.user.findUnique({
            where: { username }
        });

        if (existingUser) {
            console.log(`User '${username}' already exists.`);
            // Update password if needed, or just skip
            // await prisma.user.update({
            //     where: { username },
            //     data: { password } 
            // });
            // console.log(`Password for '${username}' updated to '${password}'`);
            return;
        }

        const user = await prisma.user.create({
            data: {
                username,
                password, 
                role: 'ADMIN',
                fullName: 'System Admin',
                isActive: true
            }
        });

        console.log(`User created successfully:`);
        console.log(`Username: ${user.username}`);
        console.log(`Password: ${password}`);
        console.log(`Role: ${user.role}`);

    } catch (e) {
        console.error('Error creating user:', e);
    } finally {
        await prisma.$disconnect();
    }
}

main();
