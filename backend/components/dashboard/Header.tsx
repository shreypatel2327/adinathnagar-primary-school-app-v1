"use client";

import Link from "next/link";

export default function Header() {
    return (
        <header className="flex items-center bg-white dark:bg-[#1a2632] p-4 pb-2 justify-between sticky top-0 z-20 shadow-sm">
            <div className="flex items-center gap-3">
                <div
                    className="bg-center bg-no-repeat bg-cover rounded-full size-10 border border-gray-200"
                    style={{ backgroundImage: 'url("https://lh3.googleusercontent.com/aida-public/AB6AXuAGGwQl1JGjyZECDJZab8DbjZpxrOs2LRuo83buYz0ZiqZHQWAg6qTp5E8ZQbUx2M4LiIN-Ygb0PQtKThovotGGWr2AqYJfIodKaQ18p-M9BmLkSOmFAVcRt_EJoEkgs9yNEOERS6tnxpKVyNEi3nolXS1IwSbMp1ws_WaN2mA7YbrJ0L2ZMNTUYfteifE8r2-BHpE7CryhpNp0ERiZ-RQ30NEAKhQdqGIQzuyA_YkjzEAzqAgRJyUobR8REZmxAg4JFun539Ns4oM")' }}
                >
                </div>
                <div>
                    <h2 className="text-[#111418] dark:text-white text-base font-bold leading-tight tracking-[-0.015em]">આદિનાથનગર પ્રાથમિક શાળા</h2>
                    <p className="text-xs text-gray-500 dark:text-gray-400 font-medium">આચાર્ય ડેશબોર્ડ</p>
                </div>
            </div>
            <button className="flex items-center justify-center rounded-full size-10 hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-[#111418] dark:text-white">
                <span className="material-symbols-outlined">notifications</span>
            </button>
        </header>
    );
}
