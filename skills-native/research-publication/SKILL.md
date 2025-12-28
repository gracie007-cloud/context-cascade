---
name: research-publication
description: Skill for research-publication
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, Task, TodoWrite
---

name: research-publication
description: Academic publication preparation for Deep Research SOP Pipeline I including
  paper writing, reproducibility artifacts, and venue submission. Use when preparing
  research for publication after Gate 3 APPROVED, submitting to conferences (NeurIPS,
  ICML, CVPR), or creating ACM artifact submissions. Ensures reproducibility checklists
  complete, supplementary materials prepared, and all artifacts publicly accessible.
version: 1.0.0
category: research
tags:
- research
- analysis
- planning
author: ruv
---

# Research Publication

Prepare research for academic publication with comprehensive reproducibility artifacts, ensuring compliance with venue requirements and ACM Artifact Evaluation standards.

## Overview

**Purpose**: Prepare and submit research for academic publication

**When to Use**:
- Quality Gate 3 APPROVED (production-ready model with artifacts)
- Submitting to academic venues (NeurIPS, ICML, CVPR, ACL, etc.)
- Creating ACM artifact submissions
- Publishing reproducibility artifacts
- Preparing supplementary materials

**Quality Gate**: Follows Gate 3 APPROVED status

**Prerequisites**:
- Research complete (Phases 1-3 of Deep Research SOP)
- Quality Gate 3 APPROVED
- Reproducibility package validated
- All artifacts archived and public

**Outputs**:
- Research paper draft (LaTeX)
- Reproducibility checklist (NeurIPS, ICML, etc.)
- Supplementary materials
- ACM artifact submission package
- Code release (GitHub with Zenodo DOI)
- Presentation slides

**Time Estimate**: 2-4 weeks
- Paper writing: 1-2 weeks
- Reproducibility checklist: 1-2 days
- Supplementary materials: 2-3 days
- Artifact submission: 2-3 days
- Revisions: 3-5 days

**Agents Used**: researcher, archivist

---

## Quick Start

### 1. Initialize Publication Project
```bash
# Create publication structure
mkdir -p publication/{paper,supplementary,code,slides}

# Initialize LaTeX project
cd publication/paper/
git init
cp ~/templates/neurips_2024.tex main.tex
```

### 2. Generate Paper Sections
```bash
# Auto-generate sections from research artifacts
python scripts/generate_paper_sections.py \
  --literature-review ../phase1-foundations/literature_review.md \
  --method-description ../phase2-development/method_card.md \
  --evaluation-results ../phase2-development/holistic_evaluation/report.md \
  --output paper/auto_generated/
```

### 3. Reproducibility Checklist
```bash
# Generate NeurIPS reproducibility checklist
python scripts/generate_reproducibility_checklist.py \
  --venue neurips \
  --artifacts ../phase3-production/ \
  --output paper/reproducibility_checklist.pdf
```

### 4. Supplementary Materials
```bash
# Package supplementary materials
python scripts/package_supplementary.py \
  --ablation-results ../phase2-development/ablations/ \
  --hyperparameters ../phase2-development/hparams/ \
  --additional-experiments ../phase2-development/experiments/ \
  --output supplementary/supplementary.pdf
```

### 5. Artifact Submission
```bash
# Prepare ACM artifact submission
python scripts/prepare_acm_artifact.py \
  --reproducibility-package ../phase3-production/reproducibility-package/ \
  --badge-level "Reproduced+Reusable" \
  --output publication/acm_artifact/
```

---

## Detailed Instructions

### Phase 1: Paper Writing (1-2 weeks)

**Objective**: Write comprehensive research paper

**Steps**:

#### 1.1 Paper Structure (Standard ML Conference)
```latex
% main.tex

\documentclass{article}
\usepackage{neurips_2024}

\title{Multi-Scale Attention for Improved Vision Transformers}

\author{
  Your Name \\
  Your Institution \\
  \texttt{email@institution.edu}
}

\begin{document}

\maketitle

\begin{abstract}
% 150-200 words summarizing:
% - Problem and motivation
% - Proposed method
% - Key results
% - Contributions
\end{abstract}

\section{Introduction}
% - Motivation (why is this problem important?)
% - Limitations of existing work (from literature review)
% - Our approach (high-level overview)
% - Contributions (3-5 bullet points)

\section{Related Work}
% - Organized by themes (from literature synthesis skill)
% - Connect each work to our approach
% - Identify gaps we address

\section{Method}
% - Problem formulation
% - Proposed architecture (from method-development skill)
% - Novel components with theoretical justification
% - Computational complexity analysis

\section{Experimental Setup}
% - Datasets
% - Baselines
% - Implementation details
% - Hyperparameters

\section{Results}
% - Main results (from holistic-evaluation skill)
% - Ablation studies
% - Comparison with baselines
% - Statistical significance tests

\section{Discussion}
% - Analysis of results
% - Limitations
% - Societal impact
% - Future work

\section{Conclusion}
% - Summary of contributions
% - Key takeaways

\section{Reproducibility Statement}
% - Link to code repository
% - Link to reproducibility package
% - Statement of reproducibility

\end{document}
```

**Deliverable**: Paper draft

---

#### 1.2 Auto-Generate Sections from Artifacts
```python
# scripts/generate_paper_sections.py

def generate_related_work(literature_review_path):
    """Generate Related Work section from literature synthesis."""
    with open(literature_review_path) as f:
        lit_review = f.read()

    # Extract key papers and organize by themes
    papers = extract_papers(lit_review)
    themes = organize_by_themes(papers)

    latex_output = "\\section{Related Work}\n\n"
    for theme, theme_papers in themes.items():
        latex_output += f"\\subsection{{{theme}}}\n\n"
        for paper in theme_papers:
            latex_output += f"{paper['summary']} \\cite{{{paper['cite_key']}}}.\n"
        latex_output += "\n"

    return latex_output

def generate_method_section(method_card_path):
    """Generate Method section from method card."""
    with open(method_card_path) as f:
        method_card = f.read()

    # Extract architecture details
    architecture = extract_architecture(method_card)

    latex_output = "\\section{Method}\n\n"
    latex_output += "\\subsection{Architecture}\n\n"
    latex_output += architecture["description"] + "\n\n"

    # Add figure
    latex_output += "\\begin{figure}[h]\n"
    latex_output += "  \\centering\n"
    latex_output += f"  \\includegraphics[width=0.8\\linewidth]{{figures/{architecture['diagram']}}}\n"
    latex_output += f"  \\caption{{{architecture['caption']}}}\n"
    latex_output += "\\end{figure}\n\n"

    return latex_output

def generate_results_section(evaluation_report_path):
    """Generate Results section from holistic evaluation."""
    with open(evaluation_report_path) as f:
        eval_report = f.read()

    # Extract tables and figures
    tables = extract_tables(eval_report)
    figures = extract_figures(eval_report)

    latex_output = "\\section{Results}\n\n"

    # Main results table
    latex_output += "\\subsection{Main Results}\n\n"
    latex_output += tables["main_results"] + "\n\n"

    # Ablation studies
    latex_output += "\\subsection{Ablation Studies}\n\n"
    latex_output += tables["ablations"] + "\n\n"

    return latex_output

# Generate all sections
generate_related_work("../phase1-foundations/literature_review.md")
generate_method_section("../phase2-development/method_card.md")
generate_results_section("../phase2-development/holistic_evaluation/report.md")
```

**Deliverable**: Auto-generated paper sections

---

### Phase 2: Reproducibility Checklist (1-2 days)

**Objective**: Complete venue-specific reproducibility checklist

**Steps**:

#### 2.1 NeurIPS Reproducibility Checklist
```markdown
# NeurIPS Reproducibility Checklist

## For all authors

1. **Code, data, and instructions to reproduce the main experimental results**
   - ✅ YES - Code: https://github.com/username/project (DOI: 10.5281/zenodo.123456)
   - ✅ YES - Data: https://zenodo.org/record/123456 (DOI: 10.5281/zenodo.123457)
   - ✅ YES - Instructions: README.md with ≤5 steps to reproduce

2. **Training code**
   - ✅ YES - Included in repository: `src/train.py`

3. **Evaluation code**
   - ✅ YES - Included in repository: `src/evaluate.py`

4. **Pre-trained models**
   - ✅ YES - Available at: https://huggingface.co/username/model

5. **README file with instructions**
   - ✅ YES - Includes: installation, data download, training, evaluation

6. **Specifics of all dependencies**
   - ✅ YES - requirements.txt with pinned versions

7. **Training hyperparameters**
   - ✅ YES - Documented in: experiments/configs/optimal_hparams.yaml

8. **Random seeds**
   - ✅ YES - Seed=42 for all experiments, documented in code and README

9. **Number of runs and error bars**
   - ✅ YES - 3 runs per configuration, reported as mean ± std

10. **Compute resources**
    - ✅ YES - 4x NVIDIA A100 80GB, ~48 hours training time

11. **Statistical significance testing**
    - ✅ YES - Paired t-tests with p-values reported in Table 2

12. **Experimental setup and datasets**
    - ✅ YES - Detailed in Section 4 (Experimental Setup)

13. **Model architecture details**
    - ✅ YES - Complete architecture in Section 3, Figure 2

14. **Hyperparameter search details**
    - ✅ YES - Bayesian optimization details in Appendix A

15. **Code to compute evaluation metrics**
    - ✅ YES - scripts/compute_metrics.py

## For datasets

16. **New dataset details**
    - ❌ N/A - Using existing public datasets (ImageNet, CIFAR-10)

17. **Dataset access**
    - ✅ YES - Download script provided: scripts/download_data.sh

18. **Data preprocessing**
    - ✅ YES - Documented in: src/data/preprocessing.py

## For computational experiments

19. **Experimental setup and hyperparameters**
    - ✅ YES - Section 4 + Appendix A

20. **Description of baselines**
    - ✅ YES - Section 4.2, Table 1

21. **Ablation studies**
    - ✅ YES - Section 5.2, Table 3

## Ethics and broader impact

22. **Broader impact statement**
    - ✅ YES - Section 6.3

23. **Potential negative societal impacts**
    - ✅ YES - Discussed in Section 6.3

24. **Safeguards**
    - ✅ YES - Bias mitigation described in Section 6.3
```

**Deliverable**: Completed reproducibility checklist

---

#### 2.2 Generate Checklist Automatically
```python
# scripts/generate_reproducibility_checklist.py

def generate_checklist(venue, artifacts_path):
    """Generate reproducibility checklist for venue."""
    checklist = {
        "neurips": neurips_checklist_template(),
        "icml": icml_checklist_template(),
        "cvpr": cvpr_checklist_template()
    }

    template = checklist[venue]

    # Auto-fill from artifacts
    template["code_url"] = extract_github_url(artifacts_path)
    template["data_url"] = extract_zenodo_url(artifacts_path, "dataset")
    template["model_url"] = extract_huggingface_url(artifacts_path)

    # Generate PDF
    generate_pdf(template, output_path)

    return template
```

**Deliverable**: Auto-generated reproducibility checklist PDF

---

### Phase 3: Supplementary Materials (2-3 days)

**Objective**: Prepare supplementary materials

**Contents**:

#### 3.1 Appendices
```latex
% supplementary.tex

\appendix

\section{Additional Experimental Results}

\subsection{Hyperparameter Sensitivity Analysis}
% - Plots showing performance vs. hyperparameter values
% - Optimal ranges identified

\subsection{Additional Ablation Studies}
% - Ablations not in main paper
% - Component interaction effects

\subsection{Qualitative Results}
% - Visualizations (attention maps, saliency, etc.)
% - Error analysis examples

\section{Proofs and Derivations}
% - Theoretical proofs
% - Mathematical derivations

\section{Implementation Details}
% - Additional architecture details
% - Training tricks
% - Optimization details

\section{Broader Impact}
% - Extended discussion of societal impacts
% - Ethical considerations
% - Limitations and potential misuse

\section{Reproducibility Details}
% - Complete hardware specifications
% - Software versions
% - Environment setup instructions
```

**Deliverable**: Supplementary materials PDF

---

#### 3.2 Additional Visualizations
```python
# scripts/generate_supplementary_figures.py

# Attention visualization
attention_weights = extract_attention_weights(model, test_images)
plot_attention_maps(attention_weights, save_path="figures/attention_supp.pdf")

# Ablation study visualizations
ablation_results = load_ablation_results("../phase2-development/ablations/")
plot_ablation_heatmap(ablation_results, save_path="figures/ablation_supp.pdf")

# Hyperparameter sensitivity
hparam_results = load_hparam_results("../phase2-development/hparams/")
plot_sensitivity_curves(hparam_results, save_path="figures/sensitivity_supp.pdf")
```

**Deliverable**: Supplementary figures

---

### Phase 4: ACM Artifact Submission (2-3 days)

**Objective**: Prepare ACM Artifact Evaluation submission

**Steps**:

#### 4.1 Artifact Package Structure
```
acm_artifact/
├── README.md               # ≤5 steps to reproduce
├── LICENSE                 # MIT, Apache, etc.
├── Dockerfile              # Complete environment
├── docker-compose.yml      # Multi-container setup (if needed)
├── src/                    # Source code
├── data/                   # Data or download script
├── scripts/                # Execution scripts
│   ├── download_data.sh
│   ├── run_experiments.sh
│   └── compare_results.py
├── results_original/       # Original results
├── requirements.txt        # Pinned dependencies
└── ARTIFACT_DESCRIPTION.md # Artifact description for reviewers
```

#### 4.2 Artifact Description
```markdown
# ARTIFACT_DESCRIPTION.md

## Artifact Summary

This artifact contains the complete code, data, and environment needed to reproduce the experimental results from the paper "Multi-Scale Attention for Improved Vision Transformers."

## Artifact Availability

- **Code**: https://github.com/username/project (DOI: 10.5281/zenodo.123456)
- **Data**: https://zenodo.org/record/123457 (DOI: 10.5281/zenodo.123457)
- **Model Weights**: https://huggingface.co/username/model

## System Requirements

- **Hardware**: 4x NVIDIA A100 80GB GPUs (or equivalent with ≥64GB VRAM)
- **Software**: Docker 20.10+, NVIDIA Docker runtime
- **Disk Space**: 600GB (100GB code + 500GB data)
- **Estimated Execution Time**: 48 hours for complete reproduction

## Reproduction Steps

1. **Build Docker image**: `docker build -t multi-scale-vit:latest .`
2. **Download data**: `bash scripts/download_data.sh`
3. **Run training**: `docker run --gpus all multi-scale-vit:latest bash scripts/run_experiments.sh`
4. **Evaluate model**: `docker run --gpus all multi-scale-vit:latest python src/evaluate.py`
5. **Compare results**: `python scripts/compare_results.py --original results_original/ --reproduced results/`

## Expected Results

- **Test Accuracy**: 87.5% ± 0.3% (reported in paper: 87.5%)
- **Training Time**: ~48 hours on 4x A100
- **Deviation**: Should be within ±1% of reported results

## Badge Request

We request the following ACM badges:
- ✅ Artifacts Available
- ✅ Artifacts Functional
- ✅ Results Reproduced
- ✅ Artifacts Reusable

## Contact

For questions about the artifact, please open an issue on GitHub: https://github.com/username/project/issues
```

**Deliverable**: ACM artifact package

---

### Phase 5: Code Release (2-3 days)

**Objective**: Publish code on GitHub with Zenodo DOI

**Steps**:

#### 5.1 GitHub Repository Setup
```bash
# Create GitHub repository
gh repo create multi-scale-vit --public --description "Multi-Scale Attention for Vision Transformers"

# Initialize repository
git init
git add .
git commit -m "Initial commit: Multi-Scale Attention for Vision Transformers"
git branch -M main
git remote add origin https://github.com/username/multi-scale-vit.git
git push -u origin main

# Create release
git tag -a v1.0.0 -m "Release for paper submission"
git push origin v1.0.0

# Create GitHub release
gh release create v1.0.0 --title "v1.0.0 - Paper Submission" --notes "Code release for Multi-Scale Attention for Vision Transformers paper"
```

#### 5.2 Zenodo DOI Assignment
```bash
# Link GitHub to Zenodo
# 1. Go to https://zenodo.org/account/settings/github/
# 2. Enable repository
# 3. Create new release on GitHub
# 4. Zenodo automatically creates DOI

# Update README with DOI
echo "[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.123456.svg)](https://doi.org/10.5281/zenodo.123456)" >> README.md
git add README.md
git commit -m "Add Zenodo DOI badge"
git push
```

**Deliverable**: GitHub repository with Zenodo DOI

---

### Phase 6: Presentation Slides (3-5 days)

**Objective**: Create presentation for conference

**Structure**:
1. **Title Slide** (1 slide)
2. **Motivation** (2-3 slides)
3. **Related Work** (1-2 slides)
4. **Method** (4-5 slides)
5. **Experiments** (3-4 slides)
6. **Results** (3-4 slides)
7. **Conclusion** (1 slide)
8. **Q&A** (1 slide)

**Total**: ~15-20 slides for 15-minute talk

**Deliverable**: Presentation slides (PowerPoint or Beamer)

---

## Integration with Deep Research SOP

### Pipeline Integration
- **Pipeline I (Publication)**: This skill implements the complete publication phase
- **Quality Gate 3**: Must be APPROVED before publication

### Agent Coordination
```
researcher agent writes paper and creates presentation
archivist agent prepares artifact submission and code release
```

---

## Troubleshooting

### Issue: Reproducibility checklist incomplete
**Solution**: Review all artifacts, ensure code/data public, complete missing sections

### Issue: ACM artifact review fails
**Solution**: Test reproducibility package, fix Docker build issues, improve README

---

## Related Skills and Commands

### Prerequisites
- `gate-validation --gate 3` - Must be APPROVED
- `reproducibility-audit` - Validates artifact quality
- `deployment-readiness` - Validates production deployment

### Related Commands
- All Phase 1-3 outputs (literature review, method card, holistic evaluation)

---

## References

### Publication Standards
- NeurIPS Reproducibility Checklist
- ICML Code Submission Guidelines
- ACM Artifact Evaluation: https://www.acm.org/publications/policies/artifact-review-and-badging-current

### LaTeX Templates
- NeurIPS: https://neurips.cc/Conferences/2024/PaperInformation/StyleFiles
- ICML: https://icml.cc/Conferences/2024/StyleAuthorInstructions
- CVPR: https://cvpr2024.thecvf.com/
---

## Core Principles

Research Publication operates on 3 fundamental principles:

### Principle 1: Reproducibility as Publication Standard
Academic publication without reproducibility artifacts is incomplete scholarship. Code, data, pre-trained models, and environment specifications must be publicly accessible for peer validation and scientific progress.

In practice:
- Reproducibility checklist (NeurIPS, ICML, CVPR) completed with ALL items marked YES or justified N/A
- GitHub repository with Zenodo DOI assigned before paper submission (permanent archival)
- Reproducibility package tested independently (5 steps to reproduce, fresh Docker, public datasets)

### Principle 2: Transparency in Methodology and Results
Every claim must be verifiable. Statistical significance tests, error bars, hyperparameter search details, and baseline comparisons must be documented for peer scrutiny.

In practice:
- 3+ runs per configuration with mean ± std reported in all tables
- Paired t-tests with p-values for statistical significance (p < 0.05 required)
- Complete hyperparameter search details (Bayesian optimization, grid search ranges) in appendix
- Ablation studies (5+ components) validate each novel contribution

### Principle 3: Ethics and Broader Impact Assessment
Publication without societal impact discussion is irresponsible. Data bias, fairness metrics, potential misuse, and limitations must be addressed for ethical research dissemination.

In practice:
- Ethics review APPROVED at Quality Gate 3 (deployment safety, fairness audit, privacy assessment)
- Broader impact statement includes: potential negative societal impacts, safeguards, limitations
- Fairness metrics (demographic parity, equalized odds) reported for production models

---

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Reproducibility as Afterthought** | Packaging code and artifacts AFTER paper acceptance leads to missing hyperparameters, broken dependencies, inaccessible data, and failed ACM Artifact Evaluation | Create reproducibility package during Phase 3 (gate-validation requirement). Test with archivist agent in fresh Docker. Assign DOIs (Zenodo, HuggingFace) before submission. Include reproducibility checklist in initial submission |
| **Ignoring Reviewer Comments** | Dismissing reviewer concerns or providing vague responses leads to paper rejection. Each comment represents a barrier to publication that MUST be addressed substantively | Create point-by-point response document addressing EVERY reviewer comment explicitly. Add requested experiments (even if Appendix), clarify confusing sections, acknowledge valid limitations. Use "We agree" for valid points, "We respectfully clarify" for misunderstandings |
| **Incomplete Anonymity (Blind Reviews)** | Self-citations, GitHub URLs, institutional affiliations in blind submissions violate anonymity and lead to desk rejection | Use "Our prior work [Anonymous, 2024]" instead of author names, host code on anonymous repositories (Anonymous GitHub), remove acknowledgments mentioning grants/institutions. Validate with venue-specific anonymity checklist |

---

## Conclusion

Research Publication is the culminating skill in Deep Research SOP Pipeline I, transforming 2-6 months of rigorous research (Phases 1-3) into peer-reviewed academic contributions with reproducibility artifacts meeting ACM Artifact Evaluation standards. By enforcing reproducibility checklists, statistical rigor, and ethics assessments, this skill ensures research meets publication standards for top-tier venues (NeurIPS, ICML, CVPR, ACL).

This skill is essential when Quality Gate 3 is APPROVED (production-ready model with validated artifacts) and research is ready for academic dissemination. The 2-4 week timeline includes paper writing (auto-generated sections from research artifacts), reproducibility checklist completion, supplementary materials preparation, ACM artifact submission, code release (GitHub with Zenodo DOI), and presentation slides (15-20 slides for conference talks).

Use this skill when preparing Deep Research SOP outputs for publication, responding to peer review (point-by-point reviewer responses), creating camera-ready versions (final formatting, acknowledgments, references), or submitting to artifact evaluation tracks (ACM badges: Available, Functional, Reproduced, Reusable). The result is a complete publication package: LaTeX paper draft, reproducibility checklist with ALL items addressed, supplementary materials (ablations, proofs, visualizations), ACM artifact submission (tested reproducibility package), public code release (GitHub + Zenodo DOI), and presentation slides. This comprehensive package maximizes publication success while advancing open science through reproducible, ethically sound research contributions.