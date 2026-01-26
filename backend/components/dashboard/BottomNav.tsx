"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";

export default function BottomNav() {
    const pathname = usePathname();

    const navItems = [
        { label: "મુખ્ય", icon: "home", href: "/admin/dashboard" },
        { label: "વિદ્યાર્થીઓ", icon: "backpack", href: "/admin/students" },
        { label: "સ્ટાફ", icon: "group", href: "/admin/staff" },
        { label: "સેટિંગ્સ", icon: "settings", href: "/admin/settings" },
    ];

    return (
        <nav className="fixed bottom-0 w-full max-w-md bg-white dark:bg-[#1a2632] border-t border-gray-200 dark:border-gray-700 flex justify-around items-center h-[72px] pb-4 z-50 left-1/2 -translate-x-1/2">
            {navItems.map((item) => {
                const isActive = pathname === item.href;
                return (
                    <Link
                        key={item.href}
                        href={item.href}
                        className={cn(
                            "flex flex-col items-center justify-center w-full h-full transition-colors gap-1",
                            isActive ? "text-primary" : "text-gray-500 dark:text-gray-400 hover:text-primary dark:hover:text-primary"
                        )}
                    >
                        <span className={cn("material-symbols-outlined", isActive && "filled")}>{item.icon}</span>
                        <span className="text-[10px] font-medium">{item.label}</span>
                    </Link>
                );
            })}
        </nav>
    );
}
