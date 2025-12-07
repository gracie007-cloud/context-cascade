import Link from 'next/link';

export const metadata = {
  title: 'The Story | Meta-Calculus',
  description: 'The research journey from initial hunch through rigorous validation.',
};

export default function StoryPage() {
  return (
    <div className="section">
      <div className="mx-auto max-w-4xl">
        <div className="animate-fade-in">
          <p className="text-primary-400 font-mono text-sm mb-2">The Research Journey</p>
          <h1 className="text-4xl font-bold mb-4">
            <span className="gradient-text">The Story</span>
          </h1>
          <p className="text-xl text-gray-300 mb-8">
            From a bold hypothesis through AI hype, rigorous audits, and computational validation
          </p>
        </div>

        {/* Featured: The Framework */}
        <Link href="/story/framework" className="card mb-8 hover:border-green-500 transition-colors group bg-gradient-to-r from-green-900/20 to-purple-900/20 md:col-span-2">
          <div className="flex items-center mb-3">
            <span className="text-green-400 font-mono text-sm mr-3">NEW: The Reframing</span>
            <span className="text-xs bg-green-500/30 text-green-400 px-2 py-0.5 rounded-full">December 2025</span>
          </div>
          <h2 className="text-2xl font-bold mb-3 group-hover:text-green-400 transition-colors">
            Scheme-Invariance Framework
          </h2>
          <p className="text-gray-300 mb-4">
            Physical laws are <strong className="text-primary-400">equivalence classes</strong> of models under scheme transformations.
            What survives under G_scheme is physics. What changes is scaffolding.
          </p>
          <div className="flex flex-wrap gap-2 mb-4">
            <span className="text-xs bg-purple-900/50 text-purple-400 px-2 py-1 rounded">QFT Renormalization</span>
            <span className="text-xs bg-blue-900/50 text-blue-400 px-2 py-1 rounded">Kramers-Wannier</span>
            <span className="text-xs bg-green-900/50 text-green-400 px-2 py-1 rounded">Wheeler-DeWitt</span>
            <span className="text-xs bg-red-900/50 text-red-400 px-2 py-1 rounded">Chiral Anomaly</span>
            <span className="text-xs bg-yellow-900/50 text-yellow-400 px-2 py-1 rounded">PDE Schemes</span>
            <span className="text-xs bg-cyan-900/50 text-cyan-400 px-2 py-1 rounded">State Geometry</span>
          </div>
          <p className="text-sm text-green-400">6 physics domains validated with 5000+ MOO evaluations &rarr;</p>
        </Link>

        {/* Chapter Cards */}
        <div className="grid gap-6 md:grid-cols-2 mb-12">
          <Link href="/story/hunch" className="card hover:border-primary-500 transition-colors group">
            <div className="flex items-center mb-3">
              <span className="text-primary-400 font-mono text-sm mr-3">Chapter 1</span>
              <div className="h-px flex-1 bg-gradient-to-r from-primary-500/50 to-transparent"></div>
            </div>
            <h2 className="text-xl font-bold mb-2 group-hover:text-primary-400 transition-colors">The Hunch</h2>
            <p className="text-gray-400 text-sm">
              What if physics weirdness is an artifact of using the wrong calculus? Exploring non-Newtonian frameworks.
            </p>
          </Link>

          <Link href="/story/audits" className="card hover:border-accent-500 transition-colors group">
            <div className="flex items-center mb-3">
              <span className="text-accent-400 font-mono text-sm mr-3">Chapter 2</span>
              <div className="h-px flex-1 bg-gradient-to-r from-accent-500/50 to-transparent"></div>
            </div>
            <h2 className="text-xl font-bold mb-2 group-hover:text-accent-400 transition-colors">AI Hype & Audits</h2>
            <p className="text-gray-400 text-sm">
              How AI overpromised, falsification saved the project, and rigorous audits revealed what actually works.
            </p>
          </Link>

          <Link href="/story/quantum" className="card hover:border-blue-500 transition-colors group">
            <div className="flex items-center mb-3">
              <span className="text-blue-400 font-mono text-sm mr-3">Chapter 3</span>
              <div className="h-px flex-1 bg-gradient-to-r from-blue-500/50 to-transparent"></div>
            </div>
            <h2 className="text-xl font-bold mb-2 group-hover:text-blue-400 transition-colors">Quantum Tests</h2>
            <p className="text-gray-400 text-sm">
              Testing meta-calculus against quantum mechanics. Which modifications preserve quantum structure?
            </p>
          </Link>

          <Link href="/story/geometry" className="card hover:border-green-500 transition-colors group">
            <div className="flex items-center mb-3">
              <span className="text-green-400 font-mono text-sm mr-3">Chapter 4</span>
              <div className="h-px flex-1 bg-gradient-to-r from-green-500/50 to-transparent"></div>
            </div>
            <h2 className="text-xl font-bold mb-2 group-hover:text-green-400 transition-colors">Multi-Geometry</h2>
            <p className="text-gray-400 text-sm">
              Stacking multiple calculi as lenses. Multi-geometry diffusion reveals scheme-robust structure.
            </p>
          </Link>
        </div>

        {/* The Arc */}
        <div className="card bg-gradient-to-r from-primary-900/30 to-accent-900/30">
          <h2 className="text-2xl font-bold mb-4">The Arc</h2>
          <div className="space-y-4">
            <div className="flex items-start">
              <div className="w-8 h-8 rounded-full bg-primary-600 flex items-center justify-center text-sm font-bold mr-4 flex-shrink-0">1</div>
              <div>
                <p className="font-semibold">Bold Hypothesis</p>
                <p className="text-sm text-gray-400">Maybe singularities and dark energy are calculus artifacts</p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="w-8 h-8 rounded-full bg-yellow-600 flex items-center justify-center text-sm font-bold mr-4 flex-shrink-0">2</div>
              <div>
                <p className="font-semibold">AI Overpromising</p>
                <p className="text-sm text-gray-400">Exciting claims that needed computational verification</p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="w-8 h-8 rounded-full bg-red-600 flex items-center justify-center text-sm font-bold mr-4 flex-shrink-0">3</div>
              <div>
                <p className="font-semibold">Rigorous Falsification</p>
                <p className="text-sm text-gray-400">Many claims failed. Bigeometric GR does not exist in consistent form.</p>
              </div>
            </div>
            <div className="flex items-start">
              <div className="w-8 h-8 rounded-full bg-green-600 flex items-center justify-center text-sm font-bold mr-4 flex-shrink-0">4</div>
              <div>
                <p className="font-semibold">Validated Insights</p>
                <p className="text-sm text-gray-400">Physical = Scheme-Robust. Multi-calculus reveals what is real.</p>
              </div>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <div className="flex justify-between items-center mt-12">
          <Link href="/" className="text-gray-400 hover:text-white transition-colors">
            &larr; Home
          </Link>
          <Link href="/story/hunch" className="btn-primary">
            Start Reading &rarr;
          </Link>
        </div>
      </div>
    </div>
  );
}
