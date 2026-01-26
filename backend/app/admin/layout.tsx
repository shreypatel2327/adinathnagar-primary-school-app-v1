import Header from "@/components/dashboard/Header";
import BottomNav from "@/components/dashboard/BottomNav";
import { ReactNode } from "react";

export default function AdminLayout({
    children,
}: {
    children: ReactNode;
}) {
    return (
        <div className="bg-background-light dark:bg-background-dark min-h-screen pb-24">
            <div className="relative flex h-full min-h-screen w-full flex-col max-w-md mx-auto bg-background-light dark:bg-background-dark shadow-2xl">
                <main className="flex-1 overflow-x-hidden">
                    {children}
                </main>
                <BottomNav />
            </div>
        </div>
    );
}
