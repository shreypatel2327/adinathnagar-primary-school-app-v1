"use client";

import Link from "next/link";
import Header from "@/components/dashboard/Header";

export default function DashboardPage() {
    return (
        <>
            <Header />
            <div className="px-4 py-3 bg-white dark:bg-[#1a2632]">
                <label className="flex flex-col h-12 w-full">
                    <div className="flex w-full flex-1 items-stretch rounded-xl h-full bg-[#f0f2f4] dark:bg-[#232e3a] overflow-hidden focus-within:ring-2 focus-within:ring-primary/50 transition-all">
                        <div className="text-[#617589] flex items-center justify-center pl-4 pr-2">
                            <span className="material-symbols-outlined text-gray-500">search</span>
                        </div>
                        <input
                            className="flex w-full min-w-0 flex-1 resize-none overflow-hidden bg-transparent text-[#111418] dark:text-white focus:outline-none border-none h-full placeholder:text-[#617589] px-2 text-sm font-normal leading-normal"
                            placeholder="નામ, GR નં, અથવા મોબાઇલ દ્વારા શોધો..."
                        />
                    </div>
                </label>
            </div>

            <div className="flex-1">
                {/* Stats Section */}
                <div className="px-4 py-4">
                    <div className="grid grid-cols-2 gap-3">
                        {/* Total Students */}
                        <div className="flex flex-col gap-2 rounded-xl p-4 bg-white dark:bg-[#1a2632] shadow-sm border border-gray-100 dark:border-gray-800">
                            <div className="flex items-center gap-2 text-primary">
                                <span className="material-symbols-outlined">groups</span>
                                <p className="text-[#111418] dark:text-white text-sm font-medium">કુલ વિદ્યાર્થી</p>
                            </div>
                            <p className="text-[#111418] dark:text-white tracking-tight text-3xl font-bold">245</p>
                        </div>
                        {/* Standards */}
                        <div className="flex flex-col gap-2 rounded-xl p-4 bg-white dark:bg-[#1a2632] shadow-sm border border-gray-100 dark:border-gray-800">
                            <div className="flex items-center gap-2 text-orange-500">
                                <span className="material-symbols-outlined">school</span>
                                <p className="text-[#111418] dark:text-white text-sm font-medium">ધોરણવાર</p>
                            </div>
                            <p className="text-[#111418] dark:text-white tracking-tight text-3xl font-bold">1-8</p>
                        </div>
                        {/* Aavak (Income/Inward) */}
                        <div className="flex flex-col gap-2 rounded-xl p-4 bg-white dark:bg-[#1a2632] shadow-sm border border-gray-100 dark:border-gray-800">
                            <div className="flex items-center gap-2 text-green-600">
                                <span className="material-symbols-outlined">move_to_inbox</span>
                                <p className="text-[#111418] dark:text-white text-sm font-medium">આવક</p>
                            </div>
                            <p className="text-[#111418] dark:text-white tracking-tight text-3xl font-bold">12</p>
                        </div>
                        {/* Javak (Expense/Outward) */}
                        <div className="flex flex-col gap-2 rounded-xl p-4 bg-white dark:bg-[#1a2632] shadow-sm border border-gray-100 dark:border-gray-800">
                            <div className="flex items-center gap-2 text-red-500">
                                <span className="material-symbols-outlined">outbox</span>
                                <p className="text-[#111418] dark:text-white text-sm font-medium">જાવક</p>
                            </div>
                            <p className="text-[#111418] dark:text-white tracking-tight text-3xl font-bold">05</p>
                        </div>
                    </div>
                </div>

                {/* Quick Actions */}
                <div className="flex flex-col">
                    <h3 className="text-[#111418] dark:text-white text-lg font-bold leading-tight tracking-[-0.015em] px-4 pb-2 pt-2">ઝડપી કાર્યો</h3>
                    <div className="grid grid-cols-1 gap-3 p-4 pt-0">
                        <Link href="/admin/students/add" className="flex w-full gap-4 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1a2632] p-4 items-center shadow-sm hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors group">
                            <div className="flex items-center justify-center size-12 rounded-full bg-primary/10 text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                                <span className="material-symbols-outlined">person_add</span>
                            </div>
                            <div className="text-left">
                                <h2 className="text-[#111418] dark:text-white text-base font-bold leading-tight">નવો વિદ્યાર્થી</h2>
                                <p className="text-xs text-gray-500 mt-1">પ્રવેશ ફોર્મ ભરો</p>
                            </div>
                            <span className="material-symbols-outlined ml-auto text-gray-400">chevron_right</span>
                        </Link>
                        <Link href="/admin/certificates/bonafide" className="flex w-full gap-4 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1a2632] p-4 items-center shadow-sm hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors group">
                            <div className="flex items-center justify-center size-12 rounded-full bg-purple-100 dark:bg-purple-900/30 text-purple-600 dark:text-purple-400 group-hover:bg-purple-600 group-hover:text-white transition-colors">
                                <span className="material-symbols-outlined">verified</span>
                            </div>
                            <div className="text-left">
                                <h2 className="text-[#111418] dark:text-white text-base font-bold leading-tight">બોનાફાઇડ</h2>
                                <p className="text-xs text-gray-500 mt-1">બોનાફાઇડ સર્ટિફિકેટ જનરેટ કરો</p>
                            </div>
                            <span className="material-symbols-outlined ml-auto text-gray-400">chevron_right</span>
                        </Link>
                        <Link href="/admin/reports" className="flex w-full gap-4 rounded-xl border border-gray-200 dark:border-gray-700 bg-white dark:bg-[#1a2632] p-4 items-center shadow-sm hover:bg-gray-50 dark:hover:bg-gray-800 transition-colors group">
                            <div className="flex items-center justify-center size-12 rounded-full bg-teal-100 dark:bg-teal-900/30 text-teal-600 dark:text-teal-400 group-hover:bg-teal-600 group-hover:text-white transition-colors">
                                <span className="material-symbols-outlined">menu_book</span>
                            </div>
                            <div className="text-left">
                                <h2 className="text-[#111418] dark:text-white text-base font-bold leading-tight">પત્રકો</h2>
                                <p className="text-xs text-gray-500 mt-1">હાજરી અને અન્ય પત્રકો</p>
                            </div>
                            <span className="material-symbols-outlined ml-auto text-gray-400">chevron_right</span>
                        </Link>
                    </div>
                </div>

                {/* Recent Activity */}
                <div className="flex flex-col pb-6">
                    <div className="flex items-center justify-between px-4 pb-2 pt-2">
                        <h3 className="text-[#111418] dark:text-white text-lg font-bold leading-tight tracking-[-0.015em]">તાજેતરની પ્રવૃત્તિ</h3>
                        <button className="text-primary text-sm font-medium">બધું જુઓ</button>
                    </div>
                    <div className="flex flex-col">
                        <div className="flex items-start gap-3 px-4 py-3 border-b border-gray-100 dark:border-gray-800">
                            <div className="mt-1 flex items-center justify-center size-8 rounded-full bg-green-100 dark:bg-green-900/30 text-green-600 text-xs font-bold">
                                NR
                            </div>
                            <div className="flex-1">
                                <p className="text-sm font-medium text-[#111418] dark:text-white">ધોરણ 3 માં નવો પ્રવેશ</p>
                                <p className="text-xs text-gray-500">વિદ્યાર્થી: રાહુલ પરમાર</p>
                            </div>
                            <span className="text-xs text-gray-400">2 કલાક પહેલા</span>
                        </div>
                        <div className="flex items-start gap-3 px-4 py-3 border-b border-gray-100 dark:border-gray-800">
                            <div className="mt-1 flex items-center justify-center size-8 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-600">
                                <span className="material-symbols-outlined text-[18px]">event_available</span>
                            </div>
                            <div className="flex-1">
                                <p className="text-sm font-medium text-[#111418] dark:text-white">રજા મંજૂર</p>
                                <p className="text-xs text-gray-500">શિક્ષક: રમેશભાઈ પટેલ</p>
                            </div>
                            <span className="text-xs text-gray-400">ગઈકાલે</span>
                        </div>
                        <div className="flex items-start gap-3 px-4 py-3">
                            <div className="mt-1 flex items-center justify-center size-8 rounded-full bg-orange-100 dark:bg-orange-900/30 text-orange-600">
                                <span className="material-symbols-outlined text-[18px]">description</span>
                            </div>
                            <div className="flex-1">
                                <p className="text-sm font-medium text-[#111418] dark:text-white">નવું પરિપત્ર આવ્યું</p>
                                <p className="text-xs text-gray-500">જિલ્લા શિક્ષણ અધિકારી કચેરી</p>
                            </div>
                            <span className="text-xs text-gray-400">2 દિવસ પહેલા</span>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
