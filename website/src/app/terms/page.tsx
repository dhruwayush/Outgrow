export default function TermsPage() {
    return (
        <div className="min-h-screen bg-[#FDFCF8] dark:bg-[#16201A] text-[#2C3E34] dark:text-[#F4F1EA] px-4 py-24 md:px-6 font-sans">
            <div className="container mx-auto max-w-3xl">
                <h1 className="text-4xl font-bold tracking-tight mb-8 font-serif">Terms of Service</h1>
                <div className="prose prose-zinc dark:prose-invert max-w-none">
                    <p className="text-zinc-500 mb-6">Last updated: {new Date().toLocaleDateString()}</p>

                    <p>
                        Please read these Terms of Service ("Terms", "Terms of Service") carefully before using the Outgrow mobile application (the "Service") operated by Outgrow ("us", "we", or "our").
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">1. Acceptance of Terms</h2>
                    <p>
                        By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">2. Use License</h2>
                    <p>
                        Permission is granted to download one copy of the materials (information or software) on Outgrow's website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">3. Disclaimer</h2>
                    <p>
                        The materials on Outgrow's Service are provided on an 'as is' basis. Outgrow makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">4. Limitations</h2>
                    <p>
                        In no event shall Outgrow or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Outgrow's Service.
                    </p>

                    <h2 className="text-2xl font-bold mt-8 mb-4 font-serif">5. Governing Law</h2>
                    <p>
                        These Terms shall be governed and construed in accordance with the laws of India, without regard to its conflict of law provisions.
                    </p>
                </div>
            </div>
        </div>
    );
}
