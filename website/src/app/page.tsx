import Link from "next/link";
import { Download, CheckCircle, Smartphone, Zap, Shield, ChevronRight, Activity, Calendar, History } from "lucide-react";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col bg-background text-foreground overflow-hidden font-sans">
      {/* Navbar */}
      <header className="fixed top-0 z-50 w-full border-b border-primary/10 bg-background/80 backdrop-blur-xl">
        <div className="container mx-auto flex h-16 items-center justify-between px-4 md:px-6">
          <div className="flex items-center gap-2">
            <div className="h-8 w-8 rounded-lg bg-primary/20 flex items-center justify-center">
              <span className="text-xl">🌱</span>
            </div>
            <span className="text-xl font-bold tracking-tight font-serif text-primary">Outgrow</span>
          </div>
          <nav className="hidden gap-6 sm:flex">
            <Link href="#features" className="text-sm font-medium text-foreground/60 hover:text-primary transition-colors">
              Features
            </Link>
            <Link href="#about" className="text-sm font-medium text-foreground/60 hover:text-primary transition-colors">
              About
            </Link>
          </nav>
          <div className="flex items-center gap-4">
            <Link
              href="#download"
              className="rounded-full bg-primary px-5 py-2 text-sm font-bold text-white transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-primary/20"
            >
              Get App
            </Link>
          </div>
        </div>
      </header>

      <main className="flex-1 pt-24">
        {/* Hero Section */}
        <section className="relative flex flex-col items-center justify-center overflow-hidden py-24 md:py-32">
          {/* Background Blobs - Organic Shapes */}
          <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[800px] h-[800px] bg-primary/5 rounded-full blur-[100px] pointer-events-none" />

          <div className="container relative mx-auto px-4 md:px-6 text-center z-10">
            <div className="inline-flex items-center rounded-full border border-primary/20 bg-primary-soft px-4 py-1.5 text-sm text-primary font-medium mb-8 transform hover:scale-105 transition-transform cursor-default">
              <span className="font-hand text-lg mr-2 rotate-[-5deg]">New!</span>
              Now available on Android
            </div>

            <h1 className="mx-auto max-w-4xl text-5xl font-bold tracking-tight md:text-7xl lg:text-8xl font-serif text-foreground leading-[1.1]">
              You're not building habits. <br />
              <span className="text-primary italic">You're exiting them.</span>
            </h1>

            <p className="mx-auto mt-8 max-w-2xl text-lg text-foreground/70 md:text-xl font-sans leading-relaxed">
              Progress isn't linear. Track the days you didn't, understand your patterns, and break free without the shame.
            </p>

            <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
              <a
                href="/outgrow.apk"
                download
                className="group relative inline-flex h-14 w-full items-center justify-center gap-2 overflow-hidden rounded-2xl bg-primary px-8 font-bold text-white transition-all hover:bg-[#548a69] hover:shadow-xl hover:shadow-primary/20 sm:w-auto"
              >
                <Download className="h-5 w-5" />
                <span>Download for Android</span>
              </a>
              <Link
                href="#features"
                className="inline-flex h-14 w-full items-center justify-center gap-2 rounded-2xl border border-primary/20 bg-primary-soft px-8 font-bold text-primary transition-colors hover:bg-primary/10 sm:w-auto"
              >
                How it works <ChevronRight className="h-4 w-4" />
              </Link>
            </div>

            {/* App Mockup */}
            <div className="mt-20 mx-auto max-w-5xl relative group perspective-1000">
              <div className="absolute -inset-4 rounded-[2rem] bg-gradient-to-tr from-primary/20 to-transparent opacity-50 blur-xl transition duration-500 group-hover:opacity-70" />
              <div className="relative aspect-[16/9] w-full overflow-hidden rounded-[2rem] border border-primary/10 bg-background/50 shadow-2xl backdrop-blur-sm flex items-center justify-center">
                {/* Placeholder for App Screen */}
                <div className="text-center p-12">
                  <div className="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-6 text-4xl">
                    🍃
                  </div>
                  <p className="font-serif text-2xl text-foreground mb-2">Beautifully Simple</p>
                  <p className="text-foreground/60">Designed to be calm, honest, and effective.</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Features Section */}
        <section id="features" className="py-32 bg-primary-soft/30">
          <div className="container mx-auto px-4 md:px-6">
            <div className="mb-20 text-center max-w-2xl mx-auto">
              <h2 className="text-3xl font-bold tracking-tight md:text-5xl font-serif text-foreground mb-6">Slip-ups are part of the process.</h2>
              <p className="text-lg text-foreground/70 leading-relaxed">
                Most habit trackers shame you for breaking a streak. Outgrow helps you learn from it instead.
              </p>
            </div>

            <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
              {[
                {
                  icon: Calendar,
                  title: "Track Clean Days",
                  description: "Focus on the days you succeeded. Relapse is allowed, but clean days are celebrated.",
                },
                {
                  icon: History,
                  title: "Learn Patterns",
                  description: "Identify triggers and patterns in your behavior to better understand yourself.",
                },
                {
                  icon: Shield,
                  title: "Private & Local",
                  description: "Your journey is personal. All data stays mainly on your device. No cloud sync by default.",
                },
                {
                  icon: Activity,
                  title: "No Shame",
                  description: "We don't use red crosses or angry notifications. Just gentle reminders to get back on track.",
                },
                {
                  icon: Smartphone,
                  title: "Calm Interface",
                  description: "A soothing, paper-like design that reduces anxiety instead of creating it.",
                },
                {
                  icon: Zap,
                  title: "Instant Check-in",
                  description: "Log your day in seconds. Frictionless tracking for when you need it most.",
                },
              ].map((feature, i) => (
                <div
                  key={i}
                  className="group relative overflow-hidden rounded-3xl border border-primary/10 bg-card p-10 shadow-sm transition-all hover:shadow-xl hover:shadow-primary/5 hover:-translate-y-1"
                >
                  <div className="mb-6 inline-flex h-14 w-14 items-center justify-center rounded-2xl bg-primary-soft text-primary">
                    <feature.icon className="h-7 w-7" />
                  </div>
                  <h3 className="mb-3 text-xl font-bold font-serif text-foreground">{feature.title}</h3>
                  <p className="text-foreground/70 leading-relaxed">{feature.description}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* Philosophy Section */}
        <section id="about" className="py-32 relative overflow-hidden">
          <div className="container relative mx-auto px-4 md:px-6">
            <div className="grid md:grid-cols-2 gap-16 items-center">
              <div>
                <span className="font-hand text-2xl text-primary font-bold mb-4 block rotate-[-2deg]">Our Philosophy</span>
                <h2 className="text-4xl md:text-5xl font-serif font-bold mb-8 leading-tight">Progress over <br /><span className="italic text-primary/80">Perfection</span></h2>
                <div className="space-y-6 text-lg text-foreground/80">
                  <p>
                    Breaking a bad habit isn't about having a perfect streak. It's about reducing the frequency over time.
                  </p>
                  <p>
                    When you slip up, it's not a failure—it's data. Outgrow helps you collect that data without judgment, so you can outgrow the habit for good.
                  </p>
                </div>
                <div className="mt-10">
                  <div className="flex items-center gap-4 text-foreground/60">
                    <span className="flex items-center gap-2"><CheckCircle className="h-5 w-5 text-primary" /> Science-backed approach</span>
                    <span className="flex items-center gap-2"><CheckCircle className="h-5 w-5 text-primary" /> Mental health focused</span>
                  </div>
                </div>
              </div>
              <div className="relative">
                <div className="absolute inset-0 bg-primary/20 rounded-full blur-[80px]" />
                <div className="relative bg-gradient-to-br from-background to-primary-soft border border-primary/10 rounded-[3rem] p-12 shadow-2xl rotate-[3deg]">
                  <p className="font-serif text-2xl md:text-3xl italic text-foreground/80 text-center leading-relaxed">
                    "The goal isn't to never mess up. The goal is to mess up less often than you used to."
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* CTA Section */}
        <section id="download" className="py-32 relative overflow-hidden bg-primary text-white">
          {/* Texture overlay */}
          <div className="absolute inset-0 opacity-10 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] mix-blend-overlay" />

          <div className="container relative mx-auto px-4 text-center md:px-6">
            <h2 className="text-4xl font-bold tracking-tight md:text-6xl font-serif mb-8 text-white">
              Ready to break free?
            </h2>
            <p className="mx-auto max-w-xl text-xl text-white/90 mb-12 font-medium">
              Join thousands of others who are reclaiming their time and focus with Outgrow.
            </p>
            <a
              href="/outgrow.apk"
              download
              className="inline-flex h-16 items-center justify-center gap-3 rounded-full bg-white px-12 text-xl font-bold text-primary transition-transform hover:scale-105 active:scale-95 hover:shadow-2xl"
            >
              <Download className="h-6 w-6" />
              Download Outgrow
            </a>
            <p className="mt-6 text-sm text-white/60 font-medium">
              Free to download • No ads • Private by design
            </p>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-primary/10 bg-background py-16 text-sm">
        <div className="container mx-auto px-4 md:px-6">
          <div className="flex flex-col md:flex-row justify-between items-center gap-8">
            <div className="flex flex-col items-center md:items-start gap-4">
              <div className="flex items-center gap-2">
                <span className="text-2xl">🌱</span>
                <span className="font-bold font-serif text-xl text-foreground">Outgrow</span>
              </div>
              <p className="text-foreground/60 max-w-xs text-center md:text-left">
                Helping you grow beyond your limits, one clean day at a time.
              </p>
            </div>

            <div className="flex gap-10">
              <div className="flex flex-col gap-3">
                <span className="font-bold text-foreground">Legal</span>
                <Link href="/privacy" className="text-foreground/60 hover:text-primary transition-colors">Privacy Policy</Link>
                <Link href="/terms" className="text-foreground/60 hover:text-primary transition-colors">Terms of Service</Link>
              </div>
              <div className="flex flex-col gap-3">
                <span className="font-bold text-foreground">Connect</span>
                <a href="mailto:support@outgrow.app" className="text-foreground/60 hover:text-primary transition-colors">Contact Support</a>
                <a href="#" className="text-foreground/60 hover:text-primary transition-colors">Twitter</a>
              </div>
            </div>
          </div>

          <div className="mt-12 pt-8 border-t border-primary/5 text-center text-foreground/40 font-medium">
            © {new Date().getFullYear()} Outgrow. Made with 💚 for better habits.
          </div>
        </div>
      </footer>
    </div>
  );
}
