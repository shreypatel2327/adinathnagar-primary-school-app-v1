"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { createStudent } from "@/actions/student";

export default function AddStudentPage() {
    const router = useRouter();

    return (
        <form action={createStudent} className="flex flex-col min-h-screen bg-background-light dark:bg-background-dark">
            {/* Top App Bar */}
            <div className="sticky top-0 z-50 flex items-center bg-white dark:bg-[#1A2633] p-4 pb-2 justify-between border-b border-[#e6e8eb] dark:border-gray-800 shadow-sm">
                <button
                    onClick={() => router.back()}
                    className="text-[#111418] dark:text-white flex size-12 shrink-0 items-center justify-start cursor-pointer hover:opacity-70"
                >
                    <span className="material-symbols-outlined text-2xl">arrow_back</span>
                </button>
                <h2 className="text-[#111418] dark:text-white text-lg font-bold leading-tight tracking-[-0.015em] flex-1 text-center pr-4">નવો વિદ્યાર્થી ઉમેરો</h2>
                <div className="flex w-auto items-center justify-end">
                    <button className="text-primary text-base font-bold leading-normal tracking-[0.015em] shrink-0 hover:text-blue-600 transition-colors">સાચવો</button>
                </div>
            </div>

            {/* Main Content */}
            <main className="flex-1 w-full max-w-md mx-auto overflow-y-auto no-scrollbar pb-32">
                {/* Section 1: Student Details */}
                <div className="flex flex-col">
                    <h3 className="text-[#111418] dark:text-gray-200 text-lg font-bold leading-tight tracking-[-0.015em] px-4 pb-2 pt-6">વિદ્યાર્થી વિગત (Student Details)</h3>
                    {/* Full Name */}
                    <div className="flex flex-wrap items-end gap-4 px-4 py-3">
                        <label className="flex flex-col min-w-40 flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">પૂરું નામ (Full Name)</p>
                            <input
                                name="fullName"
                                className="flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all"
                                placeholder="Enter student's full name"
                                required
                            />
                        </label>
                    </div>
                    {/* DOB & Standard */}
                    <div className="flex gap-4 px-4 py-1">
                        <label className="flex flex-col w-1/2">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">જન્મ તારીખ (DOB)</p>
                            <div className="relative">
                                <input
                                    name="dob"
                                    className="flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all"
                                    placeholder="DD/MM/YYYY"
                                    type="date"
                                    required
                                />
                                <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-[#617589] pointer-events-none">calendar_today</span>
                            </div>
                        </label>
                        <label className="flex flex-col w-1/2">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">ધોરણ (Std)</p>
                            <div className="relative">
                                <select name="standard" className="flex w-full min-w-0 flex-1 resize-none overflow-hidden rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] p-[15px] pr-8 text-base font-normal leading-normal appearance-none transition-all">
                                    <option disabled selected value="">Select Std</option>
                                    <option value="1">ધોરણ ૧</option>
                                    <option value="2">ધોરણ ૨</option>
                                    <option value="3">ધોરણ ૩</option>
                                    <option value="4">ધોરણ ૪</option>
                                    <option value="5">ધોરણ ૫</option>
                                    <option value="6">ધોરણ ૬</option>
                                    <option value="7">ધોરણ ૭</option>
                                    <option value="8">ધોરણ ૮</option>
                                </select>
                                <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-[#617589] pointer-events-none">arrow_drop_down</span>
                            </div>
                        </label>
                    </div>
                    {/* Gender Segmented Control */}
                    <div className="flex flex-col px-4 py-3">
                        <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">જાતિ (Gender)</p>
                        <div className="flex h-12 flex-1 items-center justify-center rounded-lg bg-[#f0f2f4] dark:bg-gray-800 p-1">
                            <label className="group flex cursor-pointer h-full grow items-center justify-center overflow-hidden rounded-md transition-all has-[:checked]:bg-white dark:has-[:checked]:bg-[#2b8cee] has-[:checked]:shadow-sm">
                                <span className="truncate text-[#617589] dark:text-gray-400 font-medium group-has-[:checked]:text-[#111418] dark:group-has-[:checked]:text-white">કુમાર (Boy)</span>
                                <input className="invisible w-0 h-0 absolute" name="gender" type="radio" value="Boy" defaultChecked />
                            </label>
                            <label className="group flex cursor-pointer h-full grow items-center justify-center overflow-hidden rounded-md transition-all has-[:checked]:bg-white dark:has-[:checked]:bg-[#2b8cee] has-[:checked]:shadow-sm">
                                <span className="truncate text-[#617589] dark:text-gray-400 font-medium group-has-[:checked]:text-[#111418] dark:group-has-[:checked]:text-white">કન્યા (Girl)</span>
                                <input className="invisible w-0 h-0 absolute" name="gender" type="radio" value="Girl" />
                            </label>
                        </div>
                    </div>
                </div>

                <div className="h-px bg-gray-200 dark:bg-gray-800 my-2 mx-4"></div>

                {/* Section 2: Family Details */}
                <div className="flex flex-col">
                    <h3 className="text-[#111418] dark:text-gray-200 text-lg font-bold leading-tight tracking-[-0.015em] px-4 pb-2 pt-4">પારિવારિક વિગત (Family Details)</h3>
                    <div className="flex flex-col gap-4 px-4 py-3">
                        <label className="flex flex-col flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">પિતાનું નામ (Father's Name)</p>
                            <input name="fatherName" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all" placeholder="Enter father's name" />
                        </label>
                        <label className="flex flex-col flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">માતાનું નામ (Mother's Name)</p>
                            <input name="motherName" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all" placeholder="Enter mother's name" />
                        </label>
                        <label className="flex flex-col flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">જાતિ/વર્ગ (Category)</p>
                            <div className="relative">
                                <select name="category" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] p-[15px] text-base font-normal leading-normal appearance-none transition-all">
                                    <option disabled selected value="">Select Category</option>
                                    <option value="general">General</option>
                                    <option value="sc">SC</option>
                                    <option value="st">ST</option>
                                    <option value="obc">OBC / SEBC</option>
                                    <option value="other">Other</option>
                                </select>
                                <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-[#617589] pointer-events-none">arrow_drop_down</span>
                            </div>
                        </label>
                        <label className="flex flex-col flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">સરનામું (Address)</p>
                            <textarea name="address" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary min-h-[100px] placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal resize-none transition-all" placeholder="Enter full address"></textarea>
                        </label>
                    </div>
                </div>

                <div className="h-px bg-gray-200 dark:bg-gray-800 my-2 mx-4"></div>

                {/* Section 3: Official Info */}
                <div className="flex flex-col">
                    <h3 className="text-[#111418] dark:text-gray-200 text-lg font-bold leading-tight tracking-[-0.015em] px-4 pb-2 pt-4">સરકારી માહિતી (Official Info)</h3>
                    <div className="flex flex-col gap-4 px-4 py-3">
                        <label className="flex flex-col flex-1">
                            <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">આધાર નંબર (Aadhaar No)</p>
                            <div className="relative">
                                <input name="aadhaarNo" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] pl-12 text-base font-normal leading-normal transition-all" maxLength={12} placeholder="0000 0000 0000" type="tel" />
                                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[#617589]">fingerprint</span>
                            </div>
                        </label>
                        <div className="flex gap-4">
                            <label className="flex flex-col w-[60%]">
                                <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">બેંક એકાઉન્ટ નંબર</p>
                                <input name="bankAccount" className="flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all" placeholder="Acct No" type="tel" />
                            </label>
                            <label className="flex flex-col w-[40%]">
                                <p className="text-[#111418] dark:text-gray-300 text-base font-medium leading-normal pb-2">IFSC કોડ</p>
                                <input name="ifscCode" className="uppercase flex w-full min-w-0 flex-1 rounded-lg text-[#111418] dark:text-white focus:outline-0 focus:ring-2 focus:ring-primary/50 border border-[#dbe0e6] dark:border-gray-700 bg-white dark:bg-[#1A2633] focus:border-primary h-14 placeholder:text-[#617589] dark:placeholder:text-gray-500 p-[15px] text-base font-normal leading-normal transition-all" placeholder="SBIN0..." type="text" />
                            </label>
                        </div>
                    </div>
                </div>
            </main>

            {/* Sticky Bottom Actions */}
            <div className="fixed bottom-0 left-0 right-0 p-4 bg-white dark:bg-[#1A2633] border-t border-[#e6e8eb] dark:border-gray-800 z-40 w-full max-w-md mx-auto">
                <button type="submit" className="flex w-full items-center justify-center rounded-xl bg-primary px-4 h-14 text-white text-base font-bold leading-normal tracking-[0.015em] shadow-md hover:bg-blue-600 transition-colors active:scale-[0.98]">
                    <span className="material-symbols-outlined mr-2">person_add</span>
                    વિદ્યાર્થી ઉમેરો (Add Student)
                </button>
            </div>
        </form>
    );
}
