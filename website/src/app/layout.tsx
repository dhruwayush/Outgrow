import type { Metadata } from "next";
import { Manrope, Merriweather, Patrick_Hand } from "next/font/google";
import "./globals.css";

const manrope = Manrope({
  variable: "--font-manrope",
  subsets: ["latin"],
});

const merriweather = Merriweather({
  weight: ["300", "400", "700", "900"],
  variable: "--font-merriweather",
  subsets: ["latin"],
});

const patrickHand = Patrick_Hand({
  weight: "400",
  variable: "--font-patrick-hand",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Outgrow | Grow beyond your limits",
  description: "Track your habits and achieve your goals with Outgrow. Download now on Android.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body
        className={`${manrope.variable} ${merriweather.variable} ${patrickHand.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
