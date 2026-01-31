export default function PrivacyPage() {
    return (
        <div className="min-h-screen bg-[#FDFCF8] dark:bg-[#16201A] text-[#2C3E34] dark:text-[#F4F1EA] px-4 py-24 md:px-6 font-sans">
            <div className="container mx-auto max-w-3xl">
                <h1 className="text-4xl font-bold tracking-tight mb-8 font-serif">Privacy Policy</h1>
                <div className="prose prose-zinc dark:prose-invert max-w-none">
                    <p className="text-zinc-500 mb-6">Last updated: {new Date().toLocaleDateString()}</p>

                    <p>
                        This Privacy Policy describes how Outgrow ("we", "us", or "our") collects, uses, and discloses your information when you use our mobile application (the "Service").
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">1. Information Collection</h2>
                    <p>
                        <strong>Personal Data:</strong> We do not collect personally identifiable information (PII) such as your name, email address, or phone number unless you voluntarily provide it to us (e.g., for support).
                    </p>
                    <p>
                        <strong>Usage Data:</strong> We may collect anonymous usage data to improve the app performance and user experience. This includes crash reports and interaction metrics.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">2. Data Storage</h2>
                    <p>
                        Outgrow is a local-first application. Your habit data, logs, and personal progress are stored locally on your device. We do not sync this data to any external servers.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">3. Third-Party Services</h2>
                    <p>
                        We may use third-party services (e.g., Google Analytics, Vercel for website hosting) that collect, monitor, and analyze this type of information in order to increase our Service's functionality. These third-party service providers have their own privacy policies addressing how they use such information.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">4. Contact Us</h2>
                    <p>
                        If you have any questions about this Privacy Policy, please contact us at: <a href="mailto:support@outgrow.app" className="text-[#65A37E] hover:underline">support@outgrow.app</a>
                    </p>
                </div>
            </div>
        </div>
    );
}
