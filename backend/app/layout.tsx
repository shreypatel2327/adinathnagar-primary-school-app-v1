import type { Metadata } from "next";
import { Public_Sans, Noto_Sans_Gujarati } from "next/font/google";
import "./globals.css";
import { cn } from "@/lib/utils";

const publicSans = Public_Sans({ subsets: ["latin"], variable: "--font-public-sans" });
const notoSansGujarati = Noto_Sans_Gujarati({ subsets: ["gujarati"], variable: "--font-noto-sans-gujarati" });

export const metadata: Metadata = {
    title: "School Management System",
    description: "Government School Management System",
};

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="gu" className={`${publicSans.variable} ${notoSansGujarati.variable}`}>
            <body className={cn("font-display min-h-screen bg-background-light dark:bg-background-dark text-slate-900 dark:text-white antialiased")}>{children}</body>
        </html>
    );
}
