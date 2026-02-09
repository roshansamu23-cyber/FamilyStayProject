/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#355E3B", // Hunter Green
        secondary: "#FFFFFF",
        accent: {
          teal: "#00BCD4",
          coral: "#FF6B6B",
          gold: "#FFD700",
        },
        status: {
          available: "#4CAF50",
          occupied: "#FF6B6B",
          pending: "#FFC107",
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
