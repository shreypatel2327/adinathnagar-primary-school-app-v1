"use client";

import Link from "next/link";

export default function StudentListPage() {
    return (
        <>
            {/* Top App Bar */}
            <header className="sticky top-0 z-20 bg-white dark:bg-[#1a2632] shadow-sm px-4 py-3 flex items-center justify-between transition-colors duration-200">
                <Link href="/admin/dashboard" className="flex items-center justify-center p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-[#111418] dark:text-white transition-colors">
                    <span className="material-symbols-outlined">arrow_back</span>
                </Link>
                <h2 className="text-lg font-bold leading-tight tracking-[-0.015em] text-[#111418] dark:text-white flex-1 text-center truncate px-2">
                    ધોરણ ૫ (Std 5)
                </h2>
                <button className="flex items-center justify-center p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 text-primary transition-colors">
                    <span className="material-symbols-outlined">filter_list</span>
                </button>
            </header>

            {/* Search Bar */}
            <div className="px-4 py-3 bg-white dark:bg-[#1a2632] transition-colors duration-200">
                <label className="flex flex-col h-12 w-full">
                    <div className="flex w-full flex-1 items-stretch rounded-xl h-full bg-[#f0f2f4] dark:bg-gray-800 overflow-hidden focus-within:ring-2 focus-within:ring-primary/50 transition-all">
                        <div className="text-gray-500 dark:text-gray-400 flex items-center justify-center pl-4 pr-2">
                            <span className="material-symbols-outlined">search</span>
                        </div>
                        <input
                            className="flex w-full min-w-0 flex-1 resize-none bg-transparent border-none text-[#111418] dark:text-white placeholder:text-gray-500 dark:placeholder:text-gray-400 focus:ring-0 focus:outline-none h-full px-2 text-base font-normal leading-normal"
                            placeholder="Search by Name or GR No..."
                        />
                    </div>
                </label>
            </div>

            {/* Filter Chips */}
            <div className="w-full overflow-x-auto no-scrollbar bg-white dark:bg-[#1a2632] pb-4 transition-colors duration-200">
                <div className="flex gap-3 px-4 min-w-max">
                    {/* Active Chip */}
                    <button className="flex h-9 items-center justify-center gap-x-2 rounded-full bg-primary px-4 shadow-sm hover:opacity-90 active:scale-95 transition-all">
                        <span className="text-white text-sm font-medium leading-normal">All Students</span>
                    </button>
                    {/* Inactive Chips */}
                    <button className="flex h-9 items-center justify-center gap-x-2 rounded-full bg-[#f0f2f4] dark:bg-gray-800 border border-transparent dark:border-gray-700 px-4 hover:bg-gray-200 dark:hover:bg-gray-700 active:scale-95 transition-all">
                        <span className="text-[#111418] dark:text-white text-sm font-medium leading-normal">Boy (કુમાર)</span>
                    </button>
                    <button className="flex h-9 items-center justify-center gap-x-2 rounded-full bg-[#f0f2f4] dark:bg-gray-800 border border-transparent dark:border-gray-700 px-4 hover:bg-gray-200 dark:hover:bg-gray-700 active:scale-95 transition-all">
                        <span className="text-[#111418] dark:text-white text-sm font-medium leading-normal">Girl (કન્યા)</span>
                    </button>
                    <button className="flex h-9 items-center justify-center gap-x-2 rounded-full bg-[#f0f2f4] dark:bg-gray-800 border border-transparent dark:border-gray-700 px-4 hover:bg-gray-200 dark:hover:bg-gray-700 active:scale-95 transition-all">
                        <span className="text-[#111418] dark:text-white text-sm font-medium leading-normal">RTE</span>
                    </button>
                </div>
            </div>

            {/* Students List Content */}
            <main className="flex-1 flex flex-col gap-3 p-4 pb-24">
                {/* List Item 1 */}
                <div className="flex flex-col sm:flex-row gap-4 bg-white dark:bg-[#1a2632] p-4 rounded-xl shadow-sm border border-transparent dark:border-gray-800 transition-colors duration-200 hover:shadow-md">
                    <div className="flex items-start gap-4 flex-1">
                        {/* Avatar */}
                        <div className="relative shrink-0">
                            <div
                                className="bg-center bg-no-repeat aspect-square bg-cover rounded-full h-16 w-16 border-2 border-gray-100 dark:border-gray-700"
                                style={{ backgroundImage: 'url("https://lh3.googleusercontent.com/aida-public/AB6AXuBK5hXdPoTxYAKC7ei4nK6bRGFJc9ySVBpCY-KLIZtg0sanw_y7p7C3mFWw_JxPsf7pleFHTJWkcr2JO_DwKSKMxHpCSStfijZjcJp3Ye6lj29jjvIN6EfAhw70Vf-f5-eVRtzGkd17-qd_huUvTm5qy8GCNKWvRFskAZB4caCLwu_nvX9Oa6cZtH20L-N9a1R7kACPldIOOA-hUJ55EzK7IaJBSDt0uH7PKdsd1Hx9tRp0XkZUSrBdOatZhbAqkgu646jy7EQ8eLc")' }}
                            >
                            </div>
                        </div>
                        {/* Info */}
                        <div className="flex flex-col justify-center flex-1 min-w-0">
                            <p className="text-[#111418] dark:text-white text-lg font-bold leading-tight truncate">
                                આરવ પટેલ <span className="text-sm font-normal text-gray-500 dark:text-gray-400 block sm:inline sm:ml-1">(Aarav Patel)</span>
                            </p>
                            <div className="flex flex-wrap gap-y-1 gap-x-3 mt-1 text-sm text-gray-500 dark:text-gray-400 font-medium">
                                <span className="bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 px-2 py-0.5 rounded text-xs">GR: 4052</span>
                                <div className="flex items-center gap-1">
                                    <span className="material-symbols-outlined text-[16px]">call</span>
                                    98765 43210
                                </div>
                            </div>
                        </div>
                    </div>
                    {/* Actions */}
                    <div className="flex items-center justify-end sm:flex-col gap-2 shrink-0 border-t sm:border-t-0 sm:border-l border-gray-100 dark:border-gray-700 pt-3 sm:pt-0 sm:pl-3 mt-2 sm:mt-0">
                        <button aria-label="View Profile" className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10 hover:bg-primary/20 text-primary transition-colors">
                            <span className="material-symbols-outlined text-[20px]">visibility</span>
                        </button>
                    </div>
                </div>

                {/* List Item 2 */}
                <div className="flex flex-col sm:flex-row gap-4 bg-white dark:bg-[#1a2632] p-4 rounded-xl shadow-sm border border-transparent dark:border-gray-800 transition-colors duration-200 hover:shadow-md">
                    <div className="flex items-start gap-4 flex-1">
                        {/* Avatar */}
                        <div className="relative shrink-0">
                            <div
                                className="bg-center bg-no-repeat aspect-square bg-cover rounded-full h-16 w-16 border-2 border-gray-100 dark:border-gray-700"
                                style={{ backgroundImage: 'url("https://lh3.googleusercontent.com/aida-public/AB6AXuB7Adf2lvA3L1GBmcu_gvvSlP7zc1DZJ6a3B4jdOJ8jMPnnVjxQm8xTKy3idyym9a_kaySlMg-UvdvxXKupgoXQq5sfYevjI5fF5SxxvMuMDTmC1L_70dfe0ZGprOBMzJAV39c_tqI63wSfges01xHV2DkbLJdZzXnjMNr78dazC7ls4E40AI4Bh3vcXz-VCuPqtfOmYwqq6WyUnHTox2eSTtSQofC3lJ3_Dxr_hEgl7HE7aRKdr4SG73FmaJq6z-3UhCr4cbO7d8c")' }}
                            >
                            </div>
                        </div>
                        {/* Info */}
                        <div className="flex flex-col justify-center flex-1 min-w-0">
                            <p className="text-[#111418] dark:text-white text-lg font-bold leading-tight truncate">
                                દિયા શાહ <span className="text-sm font-normal text-gray-500 dark:text-gray-400 block sm:inline sm:ml-1">(Diya Shah)</span>
                            </p>
                            <div className="flex flex-wrap gap-y-1 gap-x-3 mt-1 text-sm text-gray-500 dark:text-gray-400 font-medium">
                                <span className="bg-pink-50 dark:bg-pink-900/30 text-pink-700 dark:text-pink-300 px-2 py-0.5 rounded text-xs">GR: 4053</span>
                                <div className="flex items-center gap-1">
                                    <span className="material-symbols-outlined text-[16px]">call</span>
                                    98765 12345
                                </div>
                            </div>
                        </div>
                    </div>
                    {/* Actions */}
                    <div className="flex items-center justify-end sm:flex-col gap-2 shrink-0 border-t sm:border-t-0 sm:border-l border-gray-100 dark:border-gray-700 pt-3 sm:pt-0 sm:pl-3 mt-2 sm:mt-0">
                        <button aria-label="View Profile" className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10 hover:bg-primary/20 text-primary transition-colors">
                            <span className="material-symbols-outlined text-[20px]">visibility</span>
                        </button>
                    </div>
                </div>
            </main>

            {/* FAB: Add Student */}
            <Link href="/admin/students/add" className="fixed bottom-24 right-6 h-14 w-14 flex items-center justify-center rounded-full bg-primary shadow-lg hover:bg-blue-600 active:scale-95 transition-all z-30">
                <span className="material-symbols-outlined text-white text-3xl">add</span>
            </Link>
        </>
    );
}
