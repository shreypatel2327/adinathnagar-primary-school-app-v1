"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function SplashScreen() {
    const router = useRouter();

    useEffect(() => {
        const timer = setTimeout(() => {
            router.push("/login");
        }, 3000);

        return () => clearTimeout(timer);
    }, [router]);

    return (
        <div className="relative flex h-screen w-full flex-col items-center justify-between overflow-hidden bg-gradient-to-b from-white to-background-light dark:from-background-dark dark:to-[#0d141c]">
            {/* Decorative Background Circle */}
            <div className="absolute -top-32 -right-32 w-96 h-96 bg-primary/5 rounded-full blur-3xl pointer-events-none"></div>
            <div className="absolute top-1/2 left-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl pointer-events-none transform -translate-y-1/2"></div>

            {/* Top Spacer */}
            <div className="flex-1"></div>

            {/* Main Content Area: Logo & School Name */}
            <div className="z-10 flex flex-col items-center justify-center px-6 w-full max-w-sm animate-fade-in-up">
                {/* Logo Icon Container */}
                <div className="relative mb-8 p-6 bg-white dark:bg-[#1a2632] shadow-lg shadow-primary/10 rounded-2xl flex items-center justify-center">
                    <div className="absolute inset-0 bg-primary/5 rounded-2xl"></div>
                    {/* Using a material symbol as a placeholder for the school logo */}
                    <span className="material-symbols-outlined text-primary text-7xl">school</span>
                </div>

                {/* School Name (Gujarati) */}
                <h1 className="font-display text-3xl md:text-4xl font-bold text-center text-[#111418] dark:text-white leading-tight tracking-tight mb-2">
                    આદિનાથનગર <br /> પ્રાથમિક શાળા
                </h1>

                {/* Subtitle (English) */}
                <p className="text-primary font-medium text-sm tracking-wide uppercase mt-1">
                    School Management App
                </p>

                {/* Loading Indicator */}
                <div className="mt-12 w-full max-w-[200px]">
                    <div className="rounded-full bg-gray-200 dark:bg-gray-700 h-1.5 w-full overflow-hidden">
                        <div className="h-full bg-primary rounded-full w-1/3 animate-loading"></div>
                    </div>
                </div>
            </div>

            {/* Bottom Spacer */}
            <div className="flex-1"></div>

            {/* Footer: Government Branding */}
            <div className="z-10 pb-10 flex flex-col items-center justify-end gap-3 px-4 w-full opacity-80">
                {/* Emblem Image */}
                <div
                    className="h-16 w-16 bg-contain bg-center bg-no-repeat opacity-90 grayscale hover:grayscale-0 transition-all duration-500"
                    style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuBv_qcP3WV3L4knnlveuQfvQi_kjA7mZ1M99xMdsXw5TOPUgdWR-IvQDN4LF-rnMkCq0OLAl2q4ORyc_hV0eYhoHFnuS-i44ldksDhtj1cHToIGMyOrwHnQeWAWjE8C4EkftigfWx0vgWwRFiYkuh-Yu0tEAGU2UiJbtjVIWoONnUbW0yV-Eus1758AzSKlUkAIZsAyJMsII0U-JxDvi7YdiW-86z3Zzinjqf0t1IGQOKllw8XLvJeulPeahqYCmwkgCTBJ0LwQYx8')" }}
                >
                </div>

                {/* Gov Text */}
                <div className="text-center">
                    <p className="text-[#111418] dark:text-white text-xs font-bold leading-normal uppercase tracking-wide">Government of Gujarat</p>
                    <p className="text-[#617589] dark:text-gray-400 text-[10px] font-medium leading-normal">Education Department</p>
                </div>

                {/* Version Number */}
                <p className="text-gray-400 dark:text-gray-600 text-[10px] mt-2 font-mono">v1.0.0</p>
            </div>
        </div>
    );
}
