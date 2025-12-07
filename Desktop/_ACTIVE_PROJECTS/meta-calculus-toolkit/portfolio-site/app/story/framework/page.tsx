import MathBlock from '@/components/MathBlock';
import Link from 'next/link';

export const metadata = {
  title: 'Scheme-Invariance Framework | Meta-Calculus',
  description: 'A meta-theory of physics: What survives under G_scheme is physics. What changes is scaffolding.',
};

export default function FrameworkPage() {
  return (
    <div className="section">
      <div className="mx-auto max-w-4xl">
        <div className="animate-fade-in">
          <p className="text-accent-400 font-mono text-sm mb-2">The Reframing</p>
          <h1 className="text-4xl font-bold mb-4">
            <span className="gradient-text">Scheme-Invariance Framework</span>
          </h1>
          <p className="text-xl text-gray-300 mb-8">
            Physical laws are not equations in a specific mathematical language.
            Physical laws are <strong className="text-primary-400">equivalence classes</strong> of models under scheme transformations.
          </p>
        </div>

        {/* Core Principle */}
        <div className="card mb-8 bg-gradient-to-r from-primary-900/30 to-accent-900/30">
          <blockquote className="text-2xl text-center italic text-primary-300">
            What survives under G_scheme is physics.<br/>
            What changes is scaffolding.
          </blockquote>
        </div>

        {/* Two Layers */}
        <div className="card mb-8">
          <h2 className="text-2xl font-bold mb-6">Critical Distinction: Ontic vs Epistemic</h2>

          <div className="grid md:grid-cols-2 gap-6">
            <div className="bg-green-900/20 border border-green-500/30 rounded-lg p-6">
              <h3 className="text-xl font-bold text-green-400 mb-4">LAYER 1: Ontic (The World)</h3>
              <p className="text-gray-300 mb-4">
                What <strong>exists</strong> independently of how we describe it:
              </p>
              <ul className="space-y-2 text-sm text-gray-400">
                <li className="flex items-start">
                  <span className="text-green-400 mr-2">1.</span>
                  <span><strong>Least Action:</strong> Physical trajectories satisfy delta S[q;s] = 0</span>
                </li>
                <li className="flex items-start">
                  <span className="text-green-400 mr-2">2.</span>
                  <span><strong>Scheme Invariance:</strong> O(q,s) = O(g.q, g.s) for all g in G_scheme</span>
                </li>
              </ul>
              <p className="text-green-300 mt-4 text-sm font-medium">
                Scheme-invariant quantities are REAL (ontic).
              </p>
            </div>

            <div className="bg-blue-900/20 border border-blue-500/30 rounded-lg p-6">
              <h3 className="text-xl font-bold text-blue-400 mb-4">LAYER 2: Epistemic (Our Descriptions)</h3>
              <p className="text-gray-300 mb-4">
                How we <strong>choose to describe</strong> physical reality:
              </p>
              <ul className="space-y-2 text-sm text-gray-400">
                <li className="flex items-start">
                  <span className="text-blue-400 mr-2">1.</span>
                  <span><strong>Information Parsimony:</strong> Among equivalent schemes, prefer argmin I[s]</span>
                </li>
                <li className="flex items-start">
                  <span className="text-blue-400 mr-2">2.</span>
                  <span><strong>Coding Conventions:</strong> Complexity depends on language choice</span>
                </li>
              </ul>
              <p className="text-blue-300 mt-4 text-sm font-medium">
                Layer 2 is PRAGMATIC (epistemic), not physics.
              </p>
            </div>
          </div>

          <div className="mt-6 p-4 bg-red-900/20 border border-red-500/30 rounded-lg">
            <p className="text-red-300 text-sm">
              <strong>CRITICAL RULE:</strong> Layer 2 is used ONLY AFTER Layer 1 establishes physical equivalence.
              Never use information criteria to determine physical content!
            </p>
          </div>
        </div>

        {/* The Two-Axis Scheme Space */}
        <div className="card mb-8">
          <h2 className="text-2xl font-bold mb-6">The Two-Axis Scheme Space</h2>
          <p className="text-gray-300 mb-4">
            A <strong>scheme</strong> is a pair s = (A, C) where:
          </p>

          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <h3 className="text-lg font-bold text-purple-400 mb-3">A-Scheme (Algebra)</h3>
              <p className="text-sm text-gray-400 mb-3">Choice of number system and representation</p>
              <div className="bg-dark-bg rounded-lg p-4 text-sm">
                <div className="space-y-2">
                  <div className="flex justify-between"><span className="text-gray-400">A1: Complex QT</span><span className="text-purple-400">Standard QM</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">A2: Real NQT</span><span className="text-purple-400">Hoffreumon-Woods 2025</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">A3: Kahler</span><span className="text-purple-400">Geometric QM</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">A4: Quaternionic</span><span className="text-purple-400">Extended QM</span></div>
                </div>
              </div>
            </div>

            <div>
              <h3 className="text-lg font-bold text-cyan-400 mb-3">C-Scheme (Calculus)</h3>
              <p className="text-sm text-gray-400 mb-3">Choice of differential/evolution structure</p>
              <div className="bg-dark-bg rounded-lg p-4 text-sm">
                <div className="space-y-2">
                  <div className="flex justify-between"><span className="text-gray-400">C1: Classical</span><span className="text-cyan-400">Newton, Schrodinger</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">C2: Meta-time</span><span className="text-cyan-400">Meta-calculus</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">C3: Bigeometric</span><span className="text-cyan-400">Scale-invariant</span></div>
                  <div className="flex justify-between"><span className="text-gray-400">C4: Multi-operator</span><span className="text-cyan-400">Diffusion bundles</span></div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* G_scheme Groupoid */}
        <div className="card mb-8">
          <h2 className="text-2xl font-bold mb-6">The G_scheme Groupoid</h2>
          <p className="text-gray-300 mb-4">
            G_scheme is a <strong>groupoid</strong> of admissible morphisms between schemes:
          </p>

          <div className="bg-dark-bg rounded-lg p-4 font-mono text-center mb-6">
            g: (q, s) --&gt; (q&apos;, s&apos;)
          </div>

          <h3 className="text-lg font-bold text-primary-400 mb-4">The Five Admissibility Axioms</h3>
          <p className="text-sm text-gray-400 mb-4">A transformation g is IN G_scheme iff it satisfies ALL of:</p>

          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-gray-700">
                  <th className="text-left p-3 text-gray-400">Axiom</th>
                  <th className="text-left p-3 text-gray-400">Requirement</th>
                  <th className="text-left p-3 text-gray-400">Why It Matters</th>
                </tr>
              </thead>
              <tbody>
                <tr className="border-b border-gray-800">
                  <td className="p-3 text-primary-400 font-mono">preserves_spectrum</td>
                  <td className="p-3 text-gray-300">Eigenvalues unchanged</td>
                  <td className="p-3 text-gray-400">Measurements are eigenvalues</td>
                </tr>
                <tr className="border-b border-gray-800">
                  <td className="p-3 text-primary-400 font-mono">preserves_expectations</td>
                  <td className="p-3 text-gray-300">Probabilities agree</td>
                  <td className="p-3 text-gray-400">Statistical predictions match</td>
                </tr>
                <tr className="border-b border-gray-800">
                  <td className="p-3 text-primary-400 font-mono">is_local</td>
                  <td className="p-3 text-gray-300">No nonlocal dependence</td>
                  <td className="p-3 text-gray-400">Causality preservation</td>
                </tr>
                <tr className="border-b border-gray-800">
                  <td className="p-3 text-primary-400 font-mono">is_invertible</td>
                  <td className="p-3 text-gray-300">Bijective transformation</td>
                  <td className="p-3 text-gray-400">Can always go back</td>
                </tr>
                <tr className="border-b border-gray-800">
                  <td className="p-3 text-primary-400 font-mono">is_smooth</td>
                  <td className="p-3 text-gray-300">Differentiable in domain</td>
                  <td className="p-3 text-gray-400">Well-defined calculus</td>
                </tr>
              </tbody>
            </table>
          </div>

          <p className="text-yellow-300 text-sm mt-4">
            <strong>Key Insight:</strong> This prevents trivialization. Not &quot;anything goes&quot; - only tame, physically sensible transformations count.
          </p>
        </div>

        {/* Domain-Specific Invariants */}
        <div className="card mb-8">
          <h2 className="text-2xl font-bold mb-6">Domain-Specific Invariants</h2>

          <div className="space-y-6">
            <div>
              <h3 className="text-lg font-bold text-yellow-400 mb-3">FRW Cosmology</h3>
              <div className="grid md:grid-cols-2 gap-4">
                <div className="bg-green-900/20 rounded-lg p-4">
                  <h4 className="text-green-400 font-medium mb-2">Scheme-Robust (Physical)</h4>
                  <ul className="text-sm text-gray-300 space-y-1">
                    <li>- H(z) Hubble parameter</li>
                    <li>- BBN abundances</li>
                    <li>- CMB distance measures</li>
                    <li>- Dark energy density</li>
                  </ul>
                </div>
                <div className="bg-gray-800/50 rounded-lg p-4">
                  <h4 className="text-gray-400 font-medium mb-2">Scheme-Dependent (Scaffolding)</h4>
                  <ul className="text-sm text-gray-500 space-y-1">
                    <li>- Coordinate time t</li>
                    <li>- Friedmann equation form</li>
                    <li>- Singularity at t=0 (maybe)</li>
                    <li>- Calculus used</li>
                  </ul>
                </div>
              </div>
            </div>

            <div>
              <h3 className="text-lg font-bold text-purple-400 mb-3">Quantum Mechanics</h3>
              <div className="grid md:grid-cols-2 gap-4">
                <div className="bg-green-900/20 rounded-lg p-4">
                  <h4 className="text-green-400 font-medium mb-2">Scheme-Robust (Physical)</h4>
                  <ul className="text-sm text-gray-300 space-y-1">
                    <li>- Probabilities (real)</li>
                    <li>- Interference patterns</li>
                    <li>- Entanglement correlations</li>
                    <li>- Observable spectra</li>
                  </ul>
                </div>
                <div className="bg-gray-800/50 rounded-lg p-4">
                  <h4 className="text-gray-400 font-medium mb-2">Scheme-Dependent (Scaffolding)</h4>
                  <ul className="text-sm text-gray-500 space-y-1">
                    <li>- Complex amplitudes</li>
                    <li>- Literal i symbol</li>
                    <li>- Hilbert space dimension</li>
                    <li>- Tensor product choice</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Six Research Directions */}
        <div className="card mb-8 bg-gradient-to-r from-purple-900/20 to-cyan-900/20">
          <h2 className="text-2xl font-bold mb-6">Six Research Directions</h2>
          <p className="text-gray-300 mb-6">
            We implemented scheme-invariance testing across six physics domains, each with multi-objective optimization:
          </p>

          <div className="grid gap-4 md:grid-cols-2">
            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-purple-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-purple-400 mb-2">1. QFT Renormalization</h3>
              <p className="text-sm text-gray-400">
                MS-bar, on-shell, MOM schemes as C-schemes. Pole masses and S-matrix elements are scheme-invariant physical observables.
              </p>
              <p className="text-xs text-purple-300 mt-2">900 MOO evaluations, inv_penalty = 0</p>
            </Link>

            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-blue-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-blue-400 mb-2">2. Kramers-Wannier Duality</h3>
              <p className="text-sm text-gray-400">
                High-T/Low-T duality as scheme morphism in 2D Ising. Self-dual K_c = 0.4407 identifies critical temperature.
              </p>
              <p className="text-xs text-blue-300 mt-2">Free energy invariant under duality</p>
            </Link>

            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-green-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-green-400 mb-2">3. Wheeler-DeWitt Ordering</h3>
              <p className="text-sm text-gray-400">
                Operator ordering parameter p in quantum cosmology. Laplace-Beltrami (p=1) is covariant choice.
              </p>
              <p className="text-xs text-green-300 mt-2">WKB limits provide scheme-robust observables</p>
            </Link>

            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-red-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-red-400 mb-2">4. Chiral Anomaly Detection</h3>
              <p className="text-sm text-gray-400">
                Anomalies as G_scheme obstructions. Chiral rotations with Jacobian phase FAIL the scheme-invariance criterion.
              </p>
              <p className="text-xs text-red-300 mt-2">Cohomological obstruction = non-zero phase</p>
            </Link>

            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-yellow-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-yellow-400 mb-2">5. PDE Numerical Schemes</h3>
              <p className="text-sm text-gray-400">
                Wave equation with time_scaling, spatial_weight, CFL as C-scheme parameters. Auto-tuner for numerical GR.
              </p>
              <p className="text-xs text-yellow-300 mt-2">Minimizes error, runtime, energy drift</p>
            </Link>

            <Link href="/tools/simulations" className="bg-dark-bg rounded-lg p-4 border-l-4 border-cyan-500 hover:bg-dark-surface transition-colors">
              <h3 className="font-semibold text-cyan-400 mb-2">6. Quantum State Geometry</h3>
              <p className="text-sm text-gray-400">
                Fubini-Study vs Bures metrics as C-schemes on state space. Multi-geometry diffusion finds scheme-robust features.
              </p>
              <p className="text-xs text-cyan-300 mt-2">99.9% agreement in optimal configurations</p>
            </Link>
          </div>

          <div className="mt-6 text-center">
            <Link href="/tools/simulations" className="btn-primary">
              View Interactive Simulations &rarr;
            </Link>
          </div>
        </div>

        {/* Anomalies as Obstructions */}
        <div className="card mb-8">
          <h2 className="text-2xl font-bold mb-6">Anomalies as G_scheme Obstructions</h2>
          <p className="text-gray-300 mb-4">
            In QFT, <strong>anomalies</strong> arise when:
          </p>
          <ol className="list-decimal list-inside space-y-2 text-gray-300 mb-6">
            <li>You try to make a symmetry transformation on fields</li>
            <li>Classically, the action is invariant</li>
            <li>BUT: The path integral measure picks up a nontrivial Jacobian</li>
          </ol>

          <div className="bg-dark-bg rounded-lg p-4 mb-4">
            <p className="text-gray-400 text-sm mb-2">The key formula:</p>
            <div className="font-mono text-center text-primary-400">
              det(D&apos;) / det(D) = exp(i * anomaly_phase)
            </div>
          </div>

          <p className="text-gray-300">
            <strong className="text-red-400">Translation:</strong> Anomalies are transformations that
            <em> fail to be in G_scheme</em> because the quantum measure is not invariant.
            The Jacobian phase is the &quot;smoking gun&quot; of scheme-breaking.
          </p>
        </div>

        {/* Summary */}
        <div className="card mb-8 bg-gradient-to-r from-green-900/20 to-primary-900/20">
          <h2 className="text-2xl font-bold mb-4">Summary: The Meta-Invariance Principle</h2>
          <div className="bg-dark-bg rounded-lg p-6 font-mono text-sm">
            <p className="text-gray-400 mb-2">Physical law = {`{`}</p>
            <p className="text-green-400 ml-4">Dynamics: delta S[q;s] = 0 on Q,</p>
            <p className="text-blue-400 ml-4">Invariance: O fixed under G_scheme on S,</p>
            <p className="text-purple-400 ml-4">Selection: Pareto-optimal I[s] among equivalent schemes</p>
            <p className="text-gray-400">{`}`}</p>
          </div>
        </div>

        {/* Navigation */}
        <div className="flex justify-between items-center mt-12">
          <Link href="/story" className="text-gray-400 hover:text-white transition-colors">
            &larr; Back to Story
          </Link>
          <Link href="/tools/simulations" className="btn-primary">
            Explore Simulations &rarr;
          </Link>
        </div>
      </div>
    </div>
  );
}
