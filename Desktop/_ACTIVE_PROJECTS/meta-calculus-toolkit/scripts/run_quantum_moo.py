#!/usr/bin/env python3
"""
Run Quantum Multi-Objective Optimization

This script runs both:
1. Meta-Quantum Compatibility optimization (Schrodinger meta-derivatives)
2. Quantum Diffusion optimization (multi-calculus state diffusion)

Usage:
    python scripts/run_quantum_moo.py
"""

import json
import os
import sys
import time
import numpy as np

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'portfolio-site'))

def run_meta_quantum_optimization(n_gen=50, pop_size=30):
    """Run meta-quantum compatibility optimization."""
    print("=" * 70)
    print("META-QUANTUM COMPATIBILITY OPTIMIZATION")
    print("=" * 70)

    try:
        from pymoo.algorithms.moo.nsga2 import NSGA2
        from pymoo.optimize import minimize
        from pymoo.termination import get_termination

        from meta_calculus.quantum.quantum_objectives import MetaQuantumPymooProblem

        if MetaQuantumPymooProblem is None:
            print("MetaQuantumPymooProblem not available")
            return None

        # Create problem with faster settings for demo
        problem = MetaQuantumPymooProblem(
            dim=4,
            t_final=5.0,
            num_steps=500,
            seed=42
        )

        algorithm = NSGA2(pop_size=pop_size)
        termination = get_termination("n_gen", n_gen)

        print(f"Running NSGA-II: {n_gen} generations, pop_size={pop_size}")
        print("Variables: [a_u, w_u, k_global, p_power]")
        print("Objectives: [norm_drift_global, dist_global, norm_drift_power, dist_power, complexity]")

        result = minimize(
            problem,
            algorithm,
            termination,
            seed=42,
            verbose=True
        )

        # Extract Pareto front
        pareto_solutions = []
        for i, (x, f) in enumerate(zip(result.X, result.F)):
            pareto_solutions.append({
                'id': i,
                'params': {
                    'a_u': float(x[0]),
                    'w_u': float(x[1]),
                    'k_global': float(x[2]),
                    'p_power': float(x[3])
                },
                'objectives': {
                    'norm_drift_global_norm': float(f[0]),
                    'distance_global_norm': float(f[1]),
                    'norm_drift_power': float(f[2]),
                    'distance_power': float(f[3]),
                    'complexity_penalty': float(f[4])
                }
            })

        return {
            'n_solutions': len(pareto_solutions),
            'pareto_front': pareto_solutions,
            'algorithm': 'NSGA-II',
            'n_generations': n_gen,
            'problem': 'MetaQuantumCompatibility'
        }

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return None


def run_quantum_diffusion_optimization(n_gen=50, pop_size=30):
    """Run quantum diffusion optimization."""
    print("\n" + "=" * 70)
    print("QUANTUM DIFFUSION OPTIMIZATION")
    print("=" * 70)

    try:
        from pymoo.algorithms.moo.nsga2 import NSGA2
        from pymoo.optimize import minimize
        from pymoo.termination import get_termination

        from meta_calculus.quantum.quantum_objectives import QuantumDiffusionPymooProblem

        if QuantumDiffusionPymooProblem is None:
            print("QuantumDiffusionPymooProblem not available")
            return None

        # Create problem
        problem = QuantumDiffusionPymooProblem(
            num_points=200,
            num_steps=15,
            seed=42
        )

        algorithm = NSGA2(pop_size=pop_size)
        termination = get_termination("n_gen", n_gen)

        print(f"Running NSGA-II: {n_gen} generations, pop_size={pop_size}")
        print("Variables: [gamma_power, w1, w2, w3, step_size]")
        print("Objectives: [multi_var, multi_entropy_targeted, robustness_variance]")

        result = minimize(
            problem,
            algorithm,
            termination,
            seed=42,
            verbose=True
        )

        # Extract Pareto front
        pareto_solutions = []
        for i, (x, f) in enumerate(zip(result.X, result.F)):
            pareto_solutions.append({
                'id': i,
                'params': {
                    'gamma_power': float(x[0]),
                    'w1': float(x[1]),
                    'w2': float(x[2]),
                    'w3': float(x[3]),
                    'step_size': float(x[4])
                },
                'objectives': {
                    'multi_var': float(f[0]),
                    'multi_entropy_targeted': float(f[1]),
                    'robustness_variance': float(f[2])
                }
            })

        return {
            'n_solutions': len(pareto_solutions),
            'pareto_front': pareto_solutions,
            'algorithm': 'NSGA-II',
            'n_generations': n_gen,
            'problem': 'QuantumDiffusion'
        }

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return None


def print_results(results, name):
    """Print optimization results."""
    if results is None:
        print(f"\n{name}: No results")
        return

    print(f"\n{'='*70}")
    print(f"{name} RESULTS")
    print(f"{'='*70}")
    print(f"Total Pareto solutions: {results['n_solutions']}")

    pareto = results['pareto_front']

    # Sort by first objective
    obj_names = list(pareto[0]['objectives'].keys())

    print(f"\nTop 5 solutions (sorted by {obj_names[0]}):")
    sorted_pareto = sorted(pareto, key=lambda x: x['objectives'][obj_names[0]])

    for i, sol in enumerate(sorted_pareto[:5]):
        print(f"\n  Solution {i+1}:")
        print(f"    Params: {sol['params']}")
        print(f"    Objectives: {sol['objectives']}")


def save_results(meta_quantum_results, diffusion_results):
    """Save all results to JSON."""
    results_dir = os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        'results'
    )
    os.makedirs(results_dir, exist_ok=True)

    timestamp = time.strftime("%Y%m%d_%H%M%S")

    # Save meta-quantum results
    if meta_quantum_results:
        filepath = os.path.join(results_dir, f'quantum_meta_results_{timestamp}.json')
        with open(filepath, 'w') as f:
            json.dump(meta_quantum_results, f, indent=2)
        print(f"\nMeta-Quantum results saved to: {filepath}")

    # Save diffusion results
    if diffusion_results:
        filepath = os.path.join(results_dir, f'quantum_diffusion_results_{timestamp}.json')
        with open(filepath, 'w') as f:
            json.dump(diffusion_results, f, indent=2)
        print(f"Diffusion results saved to: {filepath}")

    # Save combined results
    combined = {
        'timestamp': timestamp,
        'meta_quantum': meta_quantum_results,
        'diffusion': diffusion_results
    }
    filepath = os.path.join(results_dir, f'quantum_combined_results_{timestamp}.json')
    with open(filepath, 'w') as f:
        json.dump(combined, f, indent=2)
    print(f"Combined results saved to: {filepath}")

    return filepath


def main():
    print("=" * 70)
    print("QUANTUM MULTI-OBJECTIVE OPTIMIZATION")
    print("=" * 70)
    print(f"Time: {time.strftime('%Y-%m-%d %H:%M:%S')}")

    # Run meta-quantum optimization
    meta_quantum_results = run_meta_quantum_optimization(n_gen=50, pop_size=25)
    print_results(meta_quantum_results, "META-QUANTUM COMPATIBILITY")

    # Run quantum diffusion optimization
    diffusion_results = run_quantum_diffusion_optimization(n_gen=50, pop_size=25)
    print_results(diffusion_results, "QUANTUM DIFFUSION")

    # Save results
    save_results(meta_quantum_results, diffusion_results)

    print("\n" + "=" * 70)
    print("OPTIMIZATION COMPLETE")
    print("=" * 70)

    return 0


if __name__ == "__main__":
    sys.exit(main())
