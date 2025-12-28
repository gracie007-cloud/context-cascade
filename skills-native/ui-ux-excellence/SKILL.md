---
name: ui-ux-excellence
description: Comprehensive UI/UX enhancement cascade that transforms generic websites into polished, accessible, brand-differentiated experiences. Combines constraint-based design, WCAG accessibility, micro-interactions, typography systems, and responsive refinements. Use when elevating landing pages, marketing sites, or any frontend that needs to stand out.
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep
---

# UI/UX Excellence Cascade

Transform generic websites into polished, brand-differentiated experiences through a systematic 7-phase cascade.

## Purpose

This skill combines insights from multiple specialized skills into a single comprehensive workflow for elevating frontend experiences:

- **wcag-accessibility**: WCAG 2.1 AA compliance, ARIA, keyboard navigation
- **react-specialist**: Modern component patterns, performance optimization
- **style-audit**: Code quality, consistency, maintainability
- **pptx-generation/design-principles**: Constraint-based design philosophy
- **cascade-orchestrator**: Multi-phase workflow coordination

## When to Use This Skill

- Transforming MVP/prototype into production-ready frontend
- Elevating landing pages for premium brand positioning
- Adding micro-interactions and polish to existing sites
- Ensuring accessibility compliance before launch
- Creating differentiated experiences for different market segments
- Building design systems from scratch

## Prerequisites

**Required**: HTML/CSS, Tailwind CSS (optional), JavaScript basics
**Agents**: `coder`, `reviewer`, `frontend-dev`
**MCP**: None required (operates with Claude Code built-in tools)

## The 7-Phase Cascade

```
Phase 1: Brand Analysis & Design System Definition
    |
    v
Phase 2: Accessibility Foundation (WCAG)
    |
    v
Phase 3: Typography System Implementation
    |
    v
Phase 4: Micro-interactions & Motion Design
    |
    v
Phase 5: Component Enhancement & Polish
    |
    v
Phase 6: Responsive & Mobile Refinement
    |
    v
Phase 7: Style Audit & Validation
```

---

## Phase 1: Brand Analysis & Design System Definition

### Purpose
Extract brand patterns and codify them into CSS custom properties for consistency.

### Key Activities

1. **Identify Brand Personality**
   - Professional vs Casual
   - Luxury vs Accessible
   - Bold vs Subtle
   - Modern vs Classic

2. **Define Color Palette**
   ```css
   :root {
     /* Primary - Brand identity color */
     --color-primary: #2563EB;
     --color-primary-dark: #1D4ED8;
     --color-primary-light: #3B82F6;

     /* Accent - Call-to-action, highlights */
     --color-accent: #F59E0B;
     --color-accent-dark: #D97706;

     /* Semantic - Success, warning, error */
     --color-success: #10B981;
     --color-warning: #F59E0B;
     --color-error: #EF4444;

     /* Backgrounds */
     --color-bg: #FFFFFF;
     --color-bg-dark: #0C0C0C;
     --color-surface: #F9FAFB;
     --color-surface-dark: #171717;

     /* Text - Ensure 4.5:1 contrast ratio */
     --color-text: #1F2937;
     --color-text-dark: #FAFAF9;
     --color-text-muted: #6B7280;
   }
   ```

3. **Define Spacing Scale** (8px base)
   ```css
   :root {
     --space-1: 0.25rem;   /* 4px */
     --space-2: 0.5rem;    /* 8px */
     --space-3: 0.75rem;   /* 12px */
     --space-4: 1rem;      /* 16px */
     --space-6: 1.5rem;    /* 24px */
     --space-8: 2rem;      /* 32px */
     --space-12: 3rem;     /* 48px */
     --space-16: 4rem;     /* 64px */
     --space-24: 6rem;     /* 96px */
   }
   ```

4. **Define Transitions**
   ```css
   :root {
     --transition-fast: 150ms ease;
     --transition-base: 300ms ease;
     --transition-slow: 500ms ease;
     --transition-bounce: 500ms cubic-bezier(0.34, 1.56, 0.64, 1);
     --transition-elegant: 800ms cubic-bezier(0.16, 1, 0.3, 1);
   }
   ```

### Output
- CSS custom properties file or `:root` block
- Brand personality documentation

---

## Phase 2: Accessibility Foundation (WCAG)

### Purpose
Ensure WCAG 2.1 AA compliance for legal requirements and inclusive design.

### Key Activities

1. **Implement Skip Link**
   ```html
   <a href="#main-content" class="skip-link">Skip to main content</a>
   ```
   ```css
   .skip-link {
     position: absolute;
     top: -100%;
     left: 50%;
     transform: translateX(-50%);
     z-index: 9999;
     padding: 0.75rem 1.5rem;
     background: var(--color-primary);
     color: white;
     font-weight: 600;
     border-radius: 0.5rem;
     text-decoration: none;
     transition: top 150ms ease;
   }

   .skip-link:focus {
     top: 1rem;
     outline: 3px solid var(--color-accent);
     outline-offset: 2px;
   }
   ```

2. **Enhanced Focus States**
   ```css
   :focus-visible {
     outline: 3px solid var(--color-primary);
     outline-offset: 3px;
     border-radius: 0.25rem;
   }
   ```

3. **Color Contrast Validation**
   - Normal text: minimum 4.5:1 ratio
   - Large text (18pt+): minimum 3:1 ratio
   - Use tools: WebAIM Contrast Checker, axe DevTools

4. **Semantic HTML**
   - Use `<header>`, `<main>`, `<nav>`, `<footer>` landmarks
   - Proper heading hierarchy (h1 -> h2 -> h3)
   - Button vs link distinction

5. **Reduced Motion Support**
   ```css
   @media (prefers-reduced-motion: reduce) {
     *,
     *::before,
     *::after {
       animation-duration: 0.01ms !important;
       animation-iteration-count: 1 !important;
       transition-duration: 0.01ms !important;
     }
   }
   ```

### Output
- Skip link implementation
- Focus state styles
- Reduced motion media query
- Semantic HTML structure

---

## Phase 3: Typography System Implementation

### Purpose
Create harmonious type scale with proper line heights and letter spacing.

### Key Activities

1. **Choose Typography Scale**

   **Major Third (1.25)** - Friendly, approachable:
   ```css
   --text-xs: 0.75rem;    /* 12px */
   --text-sm: 0.875rem;   /* 14px */
   --text-base: 1rem;     /* 16px */
   --text-lg: 1.25rem;    /* 20px */
   --text-xl: 1.5rem;     /* 24px */
   --text-2xl: 1.875rem;  /* 30px */
   --text-3xl: 2.25rem;   /* 36px */
   --text-4xl: 3rem;      /* 48px */
   ```

   **Perfect Fourth (1.333)** - Authoritative, premium:
   ```css
   --text-xs: 0.75rem;    /* 12px */
   --text-sm: 0.875rem;   /* 14px */
   --text-base: 1rem;     /* 16px */
   --text-lg: 1.333rem;   /* ~21px */
   --text-xl: 1.777rem;   /* ~28px */
   --text-2xl: 2.369rem;  /* ~38px */
   --text-3xl: 3.157rem;  /* ~50px */
   --text-4xl: 4.209rem;  /* ~67px */
   ```

2. **Font Pairing Strategy**

   **Professional but Warm** (B2C, Real Estate):
   ```css
   h1, h2, h3 { font-family: 'Sora', system-ui, sans-serif; }
   body { font-family: 'Inter', system-ui, sans-serif; }
   ```

   **Authoritative & Premium** (B2B, Executive):
   ```css
   h1, h2, h3 { font-family: 'Playfair Display', Georgia, serif; }
   body { font-family: 'Inter', system-ui, sans-serif; }
   ```

3. **Line Height & Letter Spacing**
   ```css
   h1, h2, h3 {
     line-height: 1.15;
     letter-spacing: -0.02em;
   }

   body {
     line-height: 1.6;  /* or 1.7 for luxury feel */
     letter-spacing: -0.01em;
   }

   p {
     max-width: 65ch;  /* Optimal reading width */
   }
   ```

### Output
- Typography scale CSS variables
- Font loading strategy
- Heading and body styles

---

## Phase 4: Micro-interactions & Motion Design

### Purpose
Add subtle animations that enhance user experience without overwhelming.

### Key Activities

1. **Scroll-triggered Animations**
   ```css
   .animate-on-scroll {
     opacity: 0;
     transform: translateY(30px);
     transition:
       opacity 0.7s cubic-bezier(0.16, 1, 0.3, 1),
       transform 0.7s cubic-bezier(0.16, 1, 0.3, 1);
     will-change: opacity, transform;
   }

   .animate-on-scroll.is-visible {
     opacity: 1;
     transform: translateY(0);
   }
   ```

2. **Intersection Observer Script**
   ```javascript
   const observer = new IntersectionObserver((entries) => {
     entries.forEach(entry => {
       if (entry.isIntersecting) {
         entry.target.classList.add('is-visible');
         observer.unobserve(entry.target);
       }
     });
   }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

   document.querySelectorAll('.animate-on-scroll')
     .forEach(el => observer.observe(el));
   ```

3. **Staggered Children Animation**
   ```css
   .stagger-children > * {
     opacity: 0;
     transform: translateY(20px);
     transition: opacity 0.5s, transform 0.5s;
   }

   .stagger-children > *:nth-child(1) { transition-delay: 0.1s; }
   .stagger-children > *:nth-child(2) { transition-delay: 0.2s; }
   .stagger-children > *:nth-child(3) { transition-delay: 0.3s; }
   /* ... continue pattern */

   .stagger-children.is-visible > * {
     opacity: 1;
     transform: translateY(0);
   }
   ```

4. **Hover Micro-interactions**

   **Lift Effect**:
   ```css
   .hover-lift {
     transition: transform 0.3s, box-shadow 0.3s;
   }
   .hover-lift:hover {
     transform: translateY(-6px);
     box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1);
   }
   ```

   **Underline Reveal**:
   ```css
   .link-underline::after {
     content: '';
     position: absolute;
     bottom: -2px;
     left: 0;
     width: 0;
     height: 2px;
     background: var(--color-accent);
     transition: width 0.3s ease;
   }
   .link-underline:hover::after {
     width: 100%;
   }
   ```

   **Button Press**:
   ```css
   .btn-press:active {
     transform: scale(0.97);
   }
   ```

5. **Noise Texture Overlay** (Premium feel)
   ```css
   body::before {
     content: '';
     position: fixed;
     inset: 0;
     pointer-events: none;
     z-index: 9999;
     opacity: 0.025;
     background-image: url("data:image/svg+xml,..."); /* noise SVG */
   }
   ```

### Output
- Animation CSS classes
- Intersection Observer script
- Hover interaction patterns

---

## Phase 5: Component Enhancement & Polish

### Purpose
Elevate individual components with consistent patterns.

### Key Activities

1. **Card Components**
   ```css
   .card {
     background: var(--color-surface);
     border: 1px solid var(--color-border);
     border-radius: var(--radius-lg);
     padding: var(--space-6);
     transition: border-color 0.3s, box-shadow 0.3s;
   }

   .card:hover {
     border-color: var(--color-accent);
     box-shadow: var(--shadow-lg);
   }
   ```

2. **Button Variants**
   ```css
   .btn-primary {
     background: var(--color-primary);
     color: white;
     padding: var(--space-4) var(--space-8);
     border-radius: var(--radius-lg);
     font-weight: 600;
     transition: background 0.2s, transform 0.15s;
   }

   .btn-primary:hover {
     background: var(--color-primary-dark);
   }

   .btn-outline {
     border: 1px solid var(--color-accent);
     color: var(--color-accent);
     background: transparent;
     transition: background 0.2s, color 0.2s;
   }

   .btn-outline:hover {
     background: var(--color-accent);
     color: var(--color-bg-dark);
   }
   ```

3. **Section Dividers**
   ```css
   .section-border {
     border-top: 1px solid var(--color-border);
   }

   .accent-line::before {
     content: '';
     display: block;
     width: 60px;
     height: 2px;
     background: var(--color-accent);
     margin-bottom: var(--space-6);
   }
   ```

4. **Glass Morphism** (Optional, modern)
   ```css
   .glass {
     background: rgba(255, 255, 255, 0.7);
     backdrop-filter: blur(12px);
     border: 1px solid rgba(255, 255, 255, 0.2);
   }
   ```

### Output
- Component CSS patterns
- Consistent border/shadow usage

---

## Phase 6: Responsive & Mobile Refinement

### Purpose
Ensure excellent experience across all device sizes.

### Key Activities

1. **Mobile-First Media Queries**
   ```css
   /* Base: Mobile */
   h1 { font-size: var(--text-3xl); }

   /* Tablet */
   @media (min-width: 640px) {
     h1 { font-size: var(--text-4xl); }
   }

   /* Desktop */
   @media (min-width: 1024px) {
     h1 { font-size: var(--text-5xl); }
   }
   ```

2. **Touch Target Sizes**
   - Minimum 44x44px for touch targets
   - Adequate spacing between interactive elements

3. **Container Width**
   ```css
   .container {
     max-width: 1200px;
     margin: 0 auto;
     padding: 0 var(--space-4);
   }

   @media (min-width: 640px) {
     .container { padding: 0 var(--space-6); }
   }

   @media (min-width: 1024px) {
     .container { padding: 0 var(--space-8); }
   }
   ```

4. **Mobile Stack Utilities**
   ```css
   @media (max-width: 640px) {
     .mobile-stack { flex-direction: column; }
     .mobile-full { width: 100%; }
   }
   ```

### Output
- Responsive typography
- Touch-friendly targets
- Mobile utility classes

---

## Phase 7: Style Audit & Validation

### Purpose
Final validation for consistency, performance, and quality.

### Validation Checklist

- [ ] All colors use CSS custom properties
- [ ] Typography follows defined scale
- [ ] Spacing uses defined scale
- [ ] Focus states visible on all interactive elements
- [ ] Skip link works correctly
- [ ] Color contrast passes WCAG AA (4.5:1)
- [ ] Animations respect prefers-reduced-motion
- [ ] No orphaned/unused CSS
- [ ] Print styles defined
- [ ] Lighthouse accessibility score >= 90
- [ ] All images have alt text
- [ ] Semantic HTML landmarks present

### Performance Checks

- [ ] CSS is minified in production
- [ ] Fonts preconnected
- [ ] Critical CSS inlined (optional)
- [ ] No layout shifts from font loading
- [ ] `will-change` used sparingly

### Output
- Validation report
- Performance metrics
- Accessibility score

---

## Usage Example

```markdown
# Invoke the UI/UX Excellence Cascade

User: "Make my landing page stand out - it looks too generic"
---

## !! SKILL COMPLETION VERIFICATION (MANDATORY) !!

**After invoking this skill, you MUST complete ALL items below before proceeding:**

### Completion Checklist

- [ ] **Agent Spawning**: Did you spawn at least 1 agent via Task()?
  - Example: `Task("Agent Name", "Task description", "agent-type-from-registry")`

- [ ] **Agent Registry Validation**: Is your agent from the registry?
  - Registry location: `claude-code-plugins/ruv-sparc-three-loop-system/agents/`
  - Valid categories: delivery, foundry, operations, orchestration, platforms, quality, research, security, specialists, tooling
  - NOT valid: Made-up agent names

- [ ] **TodoWrite Called**: Did you call TodoWrite with 5+ todos?
  - Example: `TodoWrite({ todos: [8-10 items covering all work] })`

- [ ] **Work Delegation**: Did you delegate to agents (not do work yourself)?
  - CORRECT: Agents do the implementation via Task()
  - WRONG: You write the code directly after reading skill

### Correct Pattern After Skill Invocation

```javascript
// After Skill("<skill-name>") is invoked:
[Single Message - ALL in parallel]:
  Task("Agent 1", "Description of task 1...", "agent-type-1")
  Task("Agent 2", "Description of task 2...", "agent-type-2")
  Task("Agent 3", "Description of task 3...", "agent-type-3")
  TodoWrite({ todos: [
    {content: "Task 1 description", status: "in_progress", activeForm: "Working on task 1"},
    {content: "Task 2 description", status: "pending", activeForm: "Working on task 2"},
    {content: "Task 3 description", status: "pending", activeForm: "Working on task 3"},
  ]})
```

### Wrong Pattern (DO NOT DO THIS)

```javascript
// WRONG - Reading skill and then doing work yourself:
Skill("<skill-name>")
// Then you write all the code yourself without Task() calls
// This defeats the purpose of the skill system!
```

**The skill is NOT complete until all checklist items are checked.**

---

**Remember the pattern: Skill() -> Task() -> TodoWrite() - ALWAYS**

---

## Core Principles

UI/UX Excellence operates on 3 fundamental principles:

### Principle 1: Constraint-Based Design
Limitations create consistency, and consistency creates professional polish.

In practice:
- Define CSS custom properties for colors, spacing, typography before implementation
- Use 8px spacing scale to create harmonious vertical rhythm
- Limit color palette to 5-7 colors (primary, accent, semantic, backgrounds, text)
- Establish typographic scale (major third or perfect fourth) for predictable hierarchy

### Principle 2: Accessibility as Foundation
WCAG compliance is not optional - it benefits all users, not just those with disabilities.

In practice:
- Implement skip links for keyboard navigation from the start
- Ensure 4.5:1 color contrast ratio for all text (3:1 for large text)
- Provide visible focus states on all interactive elements (3px outline offset)
- Respect prefers-reduced-motion media query to disable animations for users who need it

### Principle 3: Micro-interactions Create Differentiation
Subtle animations and hover states separate professional sites from amateur ones.

In practice:
- Add scroll-triggered animations with Intersection Observer (fade-in, slide-up)
- Implement staggered children animations for lists (0.1s, 0.2s, 0.3s delays)
- Use hover micro-interactions (lift effect, underline reveal, button press)
- Apply noise texture overlay for premium feel (0.025 opacity)

---

## Common Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Hardcoding colors/spacing in components** | Inconsistent design, difficult global changes, maintenance nightmare | Use CSS custom properties for ALL design tokens (--color-primary, --space-4) |
| **Skipping accessibility until the end** | Expensive retrofitting, missed WCAG requirements, legal risk | Build accessibility from Phase 2, test with keyboard navigation throughout development |
| **Over-animating the interface** | Motion sickness, distraction, poor performance, unprofessional feel | Limit animations to scroll-triggered and hover states, respect prefers-reduced-motion |
| **Ignoring responsive breakpoints** | Broken mobile experience, unusable on tablets, high bounce rate | Use mobile-first media queries, test at 375px, 768px, 1024px, 1440px breakpoints |
| **Not validating color contrast** | WCAG failures, unreadable text for users, accessibility lawsuits | Use WebAIM Contrast Checker or axe DevTools, enforce 4.5:1 minimum for normal text |

---

## Conclusion

UI/UX Excellence Cascade transforms generic websites into polished, brand-differentiated experiences through systematic application of design principles, accessibility standards, and micro-interactions. By following the 7-phase workflow - from brand analysis through typography implementation to final style audit - this skill ensures no aspect of user experience is overlooked.

The cascade's power lies in its integration of multiple disciplines: constraint-based design from presentation tools (pptx-generation), WCAG compliance from accessibility specialists, component patterns from React experts, and code quality validation from style auditors. This cross-functional approach produces interfaces that are not only beautiful but also accessible, performant, and maintainable.

Use this skill when elevating MVP prototypes to production quality, creating marketing sites that reflect premium brand positioning, or building design systems from scratch. The 7-phase structure provides clear checkpoints for stakeholder review, while the CSS custom properties approach ensures design changes propagate consistently across the entire application. The result is a user experience that stands out in crowded markets, converts visitors to customers, and maintains quality as the product evolves.