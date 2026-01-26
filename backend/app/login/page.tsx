"use client";

import { useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import Link from "next/link";

const LoginSchema = z.object({
    username: z.string().min(1, "Username is required"),
    password: z.string().min(1, "Password is required"),
});

export default function LoginPage() {
    const [isPending, startTransition] = useTransition();
    const form = useForm<z.infer<typeof LoginSchema>>({
        resolver: zodResolver(LoginSchema),
        defaultValues: {
            username: "",
            password: "",
        },
    });

    const onSubmit = (values: z.infer<typeof LoginSchema>) => {
        // TODO: Implement login action
        console.log(values);
    };

    return (
        <div className="flex flex-col justify-center items-center relative overflow-hidden min-h-screen">
            {/* Decorative Background Blob */}
            <div className="absolute top-[-10%] left-[-10%] w-[50%] h-[30%] bg-primary/10 rounded-full blur-[80px] pointer-events-none"></div>
            <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[30%] bg-primary/10 rounded-full blur-[80px] pointer-events-none"></div>

            <div className="w-full max-w-md px-6 py-8 relative z-10 flex flex-col items-center">
                {/* Logo Section */}
                <div className="mb-6 flex flex-col items-center gap-3 text-center">
                    <div className="p-1 rounded-full bg-white dark:bg-slate-800 shadow-sm">
                        <div
                            className="w-24 h-24 bg-center bg-no-repeat bg-cover rounded-full border border-slate-100 dark:border-slate-700"
                            style={{ backgroundImage: 'url("https://lh3.googleusercontent.com/aida-public/AB6AXuC-EAeR0cZQZjQpqrdyuG3hW5I8yUx9-CPQC4Xat8AVTZMIpCSpJvr1jaXeWqpow6AV3yQ-uuj1xHIF7cPVim3Tzq0Hsooc1eCiNshz4KsVC206avOxd8ftRJVwRjbe-R2Az7vKJ9kAdPKuwP6OoaW_Nof7NMxoreY1ehC9afZzAB4QdaFRVmQIn0md2ZqEs4hec5Q2MaUBhe6G_PuKijNpdDPI-4cQMkG_vyKQZJyNKAcOoZMb48hQhVn2cYb6jyQB4g4-tEMnomE")' }}
                        >
                        </div>
                    </div>
                </div>

                {/* Headline Text */}
                <h1 className="text-[#111418] dark:text-white tracking-tight text-[28px] md:text-[32px] font-bold leading-tight text-center pb-8">
                    શ્રી સરકારી પ્રાથમિક શાળા
                </h1>

                {/* Login Form */}
                <form onSubmit={form.handleSubmit(onSubmit)} className="w-full space-y-5">
                    {/* Username Field */}
                    <label className="flex flex-col w-full">
                        <p className="text-[#111418] dark:text-slate-200 text-base font-medium leading-normal pb-2">વપરાશકર્તા નામ</p>
                        <div className="flex w-full items-stretch rounded-lg shadow-sm">
                            <input
                                {...form.register("username")}
                                className="form-input flex-1 w-full min-w-0 resize-none overflow-hidden rounded-l-lg text-[#111418] dark:text-white bg-white dark:bg-slate-800 border border-[#dbe0e6] dark:border-slate-600 focus:outline-0 focus:ring-2 focus:ring-primary/20 focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-slate-400 p-[15px] pr-2 text-base font-normal leading-normal transition-all"
                                placeholder="Enter username"
                                type="text"
                            />
                            <div className="flex items-center justify-center px-4 bg-white dark:bg-slate-800 border border-l-0 border-[#dbe0e6] dark:border-slate-600 rounded-r-lg text-[#617589] dark:text-slate-400">
                                <span className="material-symbols-outlined text-[24px]">person</span>
                            </div>
                        </div>
                    </label>

                    {/* Password Field */}
                    <label className="flex flex-col w-full">
                        <p className="text-[#111418] dark:text-slate-200 text-base font-medium leading-normal pb-2">પાસવર્ડ</p>
                        <div className="flex w-full items-stretch rounded-lg shadow-sm">
                            <input
                                {...form.register("password")}
                                className="form-input flex-1 w-full min-w-0 resize-none overflow-hidden rounded-l-lg text-[#111418] dark:text-white bg-white dark:bg-slate-800 border border-[#dbe0e6] dark:border-slate-600 focus:outline-0 focus:ring-2 focus:ring-primary/20 focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-slate-400 p-[15px] pr-2 text-base font-normal leading-normal transition-all"
                                placeholder="Enter password"
                                type="password"
                            />
                            <div className="flex items-center justify-center px-4 bg-white dark:bg-slate-800 border border-l-0 border-[#dbe0e6] dark:border-slate-600 rounded-r-lg text-[#617589] dark:text-slate-400 cursor-pointer hover:text-primary transition-colors">
                                <Link href="#"><span className="material-symbols-outlined text-[24px]">visibility</span></Link>
                            </div>
                        </div>
                    </label>

                    {/* Forgot Password Link */}
                    <div className="flex justify-end w-full">
                        <Link href="#" className="text-primary hover:text-blue-600 text-sm font-medium transition-colors">
                            પાસવર્ડ ભૂલી ગયા છો?
                        </Link>
                    </div>

                    {/* Login Button */}
                    <button
                        type="submit"
                        disabled={isPending}
                        className="w-full flex cursor-pointer items-center justify-center overflow-hidden rounded-lg h-12 px-5 bg-primary hover:bg-blue-600 text-white text-base font-bold leading-normal tracking-[0.015em] shadow-md transition-all active:scale-[0.98]"
                    >
                        <span className="truncate">લોગિન</span>
                    </button>
                </form>

                {/* Footer Info */}
                <div className="mt-12 text-center">
                    <p className="text-sm text-slate-500 dark:text-slate-400 font-medium">
                        v1.0 • <Link href="#" className="hover:text-primary underline">સહાયતા</Link>
                    </p>
                </div>
            </div>
        </div>
    );
}
