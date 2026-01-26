import type { Config } from "tailwindcss";

const config: Config = {
    content: [
        "./pages/**/*.{js,ts,jsx,tsx,mdx}",
        "./components/**/*.{js,ts,jsx,tsx,mdx}",
        "./app/**/*.{js,ts,jsx,tsx,mdx}",
    ],
    darkMode: "class",
    theme: {
        extend: {
            colors: {
                primary: "#2b8cee",
                "background-light": "#f6f7f8",
                "background-dark": "#101922"
            },
            fontFamily: {
                display: ["Public Sans", "Noto Sans Gujarati", "sans-serif"],
                body: ["Public Sans", "Noto Sans Gujarati", "sans-serif"],
            },
            animation: {
                "fade-in-up": "fadeInUp 0.8s ease-out forwards",
                "loading": "loading 1.5s ease-in-out infinite",
            },
            keyframes: {
                fadeInUp: {
                    "0%": { opacity: "0", transform: "translate3d(0, 20px, 0)" },
                    "100%": { opacity: "1", transform: "translate3d(0, 0, 0)" },
                },
                loading: {
                    "0%": { transform: "translateX(-100%)" },
                    "100%": { transform: "translateX(300%)" },
                },
            },
        },
    },
    plugins: [],
};
export default config;
