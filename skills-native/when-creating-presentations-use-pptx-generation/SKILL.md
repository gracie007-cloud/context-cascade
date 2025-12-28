---
name: when-creating-presentations-use-pptx-generation
description: Enterprise-grade PowerPoint deck generation using evidence-based prompting, workflow enforcement, constraint-based design
allowed-tools: Read, Write, Edit, Bash, Task, TodoWrite, Glob, Grep
---

## When to Use This Skill

- **Tool Usage**: When you need to execute specific tools, lookup reference materials, or run automation pipelines
- **Reference Lookup**: When you need to access documented patterns, best practices, or technical specifications
- **Automation Needs**: When you need to run standardized workflows or pipeline processes

## When NOT to Use This Skill

- **Manual Processes**: Avoid when manual intervention is more appropriate than automated tools
- **Non-Standard Tools**: Do not use when tools are deprecated, unsupported, or outside standard toolkit

## Success Criteria

- **Tool Executed Correctly**: Verify tool runs without errors and produces expected output
- **Reference Accurate**: Confirm reference material is current and applicable
- **Pipeline Complete**: Ensure automation pipeline completes all stages successfully

## Edge Cases

- **Tool Unavailable**: Handle scenarios where required tool is not installed or accessible
- **Outdated References**: Detect when reference material is obsolete or superseded
- **Pipeline Failures**: Recover gracefully from mid-pipeline failures with clear error messages

## Guardrails

- **NEVER use deprecated tools**: Always verify tool versions and support status before execution
- **ALWAYS verify outputs**: Validate tool outputs match expected format and content
- **ALWAYS check health**: Run tool health checks before critical operations

## Evidence-Based Validation

- **Tool Health Checks**: Execute diagnostic commands to verify tool functionality before use
- **Output Validation**: Compare actual outputs against expected schemas or patterns
- **Pipeline Monitoring**: Track pipeline execution metrics and success rates

# PPTX Generation - Enterprise Presentation Creator

## Overview

Enterprise-grade PowerPoint deck generation system using evidence-based prompting techniques, workflow enforcement, and constraint-based design for professional presentations (board decks, reports, analyses). Supports 30+ slide decks with consistent visual quality and accessibility compliance.

## When to Use

- Creating board-level presentations
- Quarterly business reviews
- Technical documentation slides
- Data-heavy reports
- Executive summaries
- Client proposals
- Training materials

## Phase 1: Research Content (8 min)

### Objective
Gather and structure presentation information

### Agent: Researcher

**Step 1.1: Content Gathering**
```javascript
const contentStructure = {
  metadata: {
    title: 'Presentation Title',
    subtitle: 'Subtitle',
    author: 'Author Name',
    date: new Date(),
    audience: 'executive|technical|general',
    purpose: 'inform|persuade|instruct'
  },
  outline: [
    {
      section: 'Introduction',
      slides: ['Title', 'Agenda', 'Executive Summary']
    },
    {
      section: 'Main Content',
      slides: ['Key Points', 'Data Analysis', 'Recommendations']
    },
    {
      section: 'Conclusion',
      slides: ['Summary', 'Next Steps', 'Q&A']
    }
  ],
  dataPoints: extractDataPoints(),
  visualizations: identifyVisualizations()
};

await memory.store('pptx/content-structure', contentStructure);
```

**Step 1.2: Data Analysis**
```javascript
async function analyzeData(data) {
  return {
    tables: extractTables(data),
    charts: identifyChartOpportunities(data),
    trends: analyzeTrends(data),
    insights: generateInsights(data)
  };
}
```

### Validation Criteria
- [ ] Content structure defined
- [ ] Data points extracted
- [ ] Visualization types identified
- [ ] Outline complete

## Phase 2: Design Layout (7 min)

### Objective
Create presentation design following constraints

### Agent: Coder

**Step 2.1: Define Design System**
```javascript
const designSystem = {
  colors: {
    primary: '#2C3E50',
    secondary: '#3498DB',
    accent: '#E74C3C',
    text: '#2C3E50',
    background: '#FFFFFF'
  },
  fonts: {
    heading: { face: 'Calibri', size: 32, bold: true },
    subheading: { face: 'Calibri', size: 24, bold: true },
    body: { face: 'Calibri', size: 18 },
    caption: { face: 'Calibri', size: 14, italic: true }
  },
  layout: {
    marginX: 0.5,
    marginY: 0.5,
    titleY: 0.5,
    contentY: 1.5,
    spacing: 0.3
  },
  accessibility: {
    contrastRatio: 4.5, // WCAG 2.1 AA
    altText: true,
    readingOrder: true
  }
};

await memory.store('pptx/design-system', designSystem);
```

**Step 2.2: Create Slide Layouts**
```javascript
const slideLayouts = {
  title: {
    type: 'title',
    elements: [
      { type: 'text', content: '{title}', style: 'heading', position: { x: 1, y: 2.5 } },
      { type: 'text', content: '{subtitle}', style: 'subheading', position: { x: 1, y: 3.5 } }
    ]
  },
  content: {
    type: 'content',
    elements: [
      { type: 'text', content: '{title}', style: 'heading', position: { x: 0.5, y: 0.5 } },
      { type: 'text', content: '{body}', style: 'body', position: { x: 0.5, y: 1.5 } }
    ]
  },
  twoColumn: {
    type: 'two-column',
    elements: [
      { type: 'text', content: '{left}', position: { x: 0.5, y: 1.5, w: 4.5 } },
      { type: 'text', content: '{right}', position: { x: 5.5, y: 1.5, w: 4.5 } }
    ]
  },
  dataVisualization: {
    type: 'chart',
    elements: [
      { type: 'text', content: '{title}', style: 'heading', position: { x: 0.5, y: 0.5 } },
      { type: 'chart', chartData: '{data}', position: { x: 1, y: 1.5, w: 8, h: 4 } }
    ]
  }
};

await memory.store('pptx/layouts', slideLayouts);
```

### Validation Criteria
- [ ] Design system defined
- [ ] Color contrast meets WCAG 2.1 AA
- [ ] Layouts created
- [ ] Accessibility constraints applied

## Phase 3: Generate Slides (12 min)

### Objective
Create PowerPoint file with all slides

### Agent: Coder

**Step 3.1: Initialize Presentation**
```javascript
const pptxgen = require('pptxgenjs');
const pres = new pptxgen();

// Apply design system
pres.layout = 'LAYOUT_WIDE';
pres.author = contentStructure.metadata.author;
pres.title = contentStructure.metadata.title;
pres.subject = contentStructure.metadata.purpose;
```

**Step 3.2: Generate Slides**
```javascript
async function generateSlides(outline, designSystem, layouts) {
  for (const section of outline) {
    for (const slideData of section.slides) {
      const layout = selectLayout(slideData.type, layouts);
      const slide = pres.addSlide();

      // Add title
      slide.addText(slideData.title, {
        x: layout.title.x,
        y: layout.title.y,
        w: layout.title.w || 9,
        h: layout.title.h || 0.75,
        fontSize: designSystem.fonts.heading.size,
        bold: designSystem.fonts.heading.bold,
        color: designSystem.colors.text
      });

      // Add content based on slide type
      if (slideData.type === 'content') {
        slide.addText(slideData.content, {
          x: layout.content.x,
          y: layout.content.y,
          w: layout.content.w || 9,
          h: layout.content.h || 4,
          fontSize: designSystem.fonts.body.size,
          color: designSystem.colors.text,
          bullet: slideData.bullet || false
        });
      }

      // Add visualizations
      if (slideData.chart) {
        slide.addChart(slideData.chart.type, slideData.chart.data, {
          x: layout.chart.x,
          y: layout.chart.y,
          w: layout.chart.w,
          h: layout.chart.h,
          showTitle: true,
          showLegend: true
        });
      }

      // Add accessibility
      if (slideData.altText) {
        slide.addNotes(slideData.altText); // Alt text for screen readers
      }
    }
  }

  return pres;
}
```

**Step 3.3: Add Data Visualizations**
```javascript
function addChart(slide, chartData, position, designSystem) {
  const chartConfig = {
    x: position.x,
    y: position.y,
    w: position.w,
    h: position.h,
    chartColors: [
      designSystem.colors.primary,
      designSystem.colors.secondary,
      designSystem.colors.accent
    ],
    showLabel: true,
    showValue: true,
    showLegend: true,
    legendPos: 'r',
    valAxisMaxVal: Math.max(...chartData.values) * 1.2
  };

  slide.addChart(chartData.type, chartData.data, chartConfig);
}
```

### Validation Criteria
- [ ] All slides generated
- [ ] Design system applied consistently
- [ ] Charts and visuals rendered
- [ ] Alt text added for accessibility

## Phase 4: Validate Quality (8 min)

### Objective
Ensure accessibility and quality standards

### Agent: Coder

**Step 4.1: Accessibility Scan**
```javascript
async function scanAccessibility(pres) {
  const issues = [];

  for (const slide of pres.slides) {
    // Check color contrast
    for (const element of slide.elements) {
      if (element.color && element.background) {
        const contrast = calculateContrastRatio(element.color, element.background);
        if (contrast < 4.5) {
          issues.push({
            slide: slide.index,
            type: 'COLOR_CONTRAST',
            severity: 'HIGH',
            message: `Contrast ratio ${contrast} < 4.5 (WCAG 2.1 AA)`
          });
        }
      }
    }

    // Check alt text
    if (slide.hasImages() && !slide.hasAltText()) {
      issues.push({
        slide: slide.index,
        type: 'MISSING_ALT_TEXT',
        severity: 'HIGH',
        message: 'Images missing alt text for screen readers'
      });
    }

    // Check reading order
    if (!slide.hasReadingOrder()) {
      issues.push({
        slide: slide.index,
        type: 'READING_ORDER',
        severity: 'MEDIUM',
        message: 'Reading order not defined'
      });
    }
  }

  await memory.store('pptx/accessibility-issues', issues);
  return issues;
}
```

**Step 4.2: Quality Checks**
```javascript
const qualityChecks = {
  consistency: checkDesignConsistency(pres),
  readability: checkTextReadability(pres),
  dataIntegrity: validateChartData(pres),
  fileSize: checkFileSize(pres),
  slideCount: pres.slides.length <= 40 // Optimal for attention
};

const passed = Object.values(qualityChecks).every(check => check.passed);
```

### Validation Criteria
- [ ] WCAG 2.1 AA compliance
- [ ] No critical accessibility issues
- [ ] Quality checks passed
- [ ] File size reasonable

## Phase 5: Export Final (5 min)

### Objective
Generate final presentation file

### Agent: Coder

**Step 5.1: Generate PPTX File**
```javascript
async function exportPresentation(pres, filename) {
  await pres.writeFile({ fileName: filename });
  console.log(`✅ Presentation saved: ${filename}`);

  // Generate accessibility report
  const report = {
    filename,
    slides: pres.slides.length,
    accessibilityIssues: await memory.retrieve('pptx/accessibility-issues'),
    qualityScore: calculateQualityScore(pres),
    wcagCompliance: 'AA',
    generatedAt: new Date()
  };

  await fs.writeFile(
    filename.replace('.pptx', '-accessibility-report.json'),
    JSON.stringify(report, null, 2)
  );
}
```

**Step 5.2: Generate Documentation**
```markdown
# Presentation Documentation

## Metadata
- Title: ${metadata.title}
- Slides: ${slideCount}
- Generated: ${timestamp}

## Design System
- Colors: ${colors}
- Fonts: ${fonts}
- Accessibility: WCAG 2.1 AA

## Slide Breakdown
${outline.map(section => `
### ${section.name}
${section.slides.map(slide => `- ${slide.title}`).join('\n')}
`).join('\n')}

## Quality Metrics
- Accessibility Score: ${accessibilityScore}/100
- Readability Score: ${readabilityScore}/100
- Design Consistency: ${consistencyScore}/100
```

### Validation Criteria
- [ ] PPTX file generated
- [ ] Accessibility report created
- [ ] Documentation complete
- [ ] Ready for distribution

## Success Metrics

- All slides generated successfully
- WCAG 2.1 AA compliance achieved
- Quality score > 85/100
- File size < 50MB

## Skill Completion

Outputs:
1. **presentation.pptx**: Final PowerPoint file
2. **accessibility-report.json**: Compliance analysis
3. **presentation-doc.md**: Generation documentation
4. **slide-notes.txt**: Speaker notes

Complete when PPTX generated with WCAG 2.1 AA compliance.

---

## Core Principles

### 1. Accessibility is Non-Negotiable
All presentations must meet WCAG 2.1 AA standards to ensure inclusivity for users with disabilities.

**In practice**:
- Maintain 4.5:1 minimum contrast ratio for all text and background combinations
- Add alt text to every image, chart, and diagram for screen reader compatibility
- Define reading order explicitly so assistive tech navigates slides logically
- Use semantic structure: titles, headings, lists instead of plain text boxes
- Validate accessibility with automated scans before finalizing presentation

### 2. Design System Enforces Consistency
Define colors, fonts, layouts, and spacing upfront to ensure visual coherence across 30+ slides.

**In practice**:
- Create design system with primary/secondary/accent colors, heading/body/caption fonts
- Define reusable slide layouts: title, content, two-column, data visualization
- Apply layout templates programmatically instead of manual positioning
- Use design tokens (variables) so changes propagate automatically
- Validate consistency with automated checks: font usage, color palette, spacing

### 3. Data Visualization Over Text Walls
Transform data into charts and visuals instead of bullet-point lists to improve comprehension and retention.

**In practice**:
- Identify data points in content and recommend chart types (bar, line, pie, scatter)
- Analyze trends and generate insights to accompany visualizations
- Use consistent chart styling (colors, legends, labels) from design system
- Add context: titles, captions, annotations to explain what data means
- Limit text slides: aim for 80% visual content, 20% text-only slides

---

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| **Manual Positioning** | Placing text boxes and images by hand leads to inconsistent alignment, spacing, and visual chaos across slides | Use predefined layout templates with fixed positions. Apply programmatically. Define margin, spacing, and grid constants in design system. |
| **Color Contrast Failures** | Low contrast between text and background (e.g., light gray on white) makes slides unreadable and fails WCAG compliance | Calculate contrast ratios programmatically. Reject color combinations below 4.5:1. Use dark text on light backgrounds or light text on dark backgrounds. |
| **Missing Alt Text** | Images, charts, and diagrams without alt text exclude screen reader users and fail accessibility standards | Add alt text to every visual element. Store in slide notes for screen readers. Validate presence of alt text in accessibility scan before export. |
| **Text Overload** | Dense bullet-point lists and paragraph-heavy slides cause audience disengagement and poor retention | Transform lists into visuals: use icons, diagrams, charts. Apply 1 idea per slide rule. Use progressive disclosure across multiple slides. |
| **Inconsistent Styling** | Random font sizes, colors, and layouts across slides creates unprofessional appearance and cognitive load | Define design system upfront. Apply templates consistently. Use design tokens. Run consistency validation before export. |
| **Stale Examples** | Hardcoded data in charts becomes outdated quickly, eroding trust in presentation content | Extract data from live sources or databases. Generate charts programmatically. Add timestamps to data slides. Update before each presentation. |

---

## Conclusion

Enterprise-grade presentations are not built slide-by-slide with manual formatting - they are generated systematically from structured content, design systems, and accessibility constraints. By enforcing WCAG 2.1 AA compliance, applying consistent design systems, and prioritizing data visualization over text walls, the pptx-generation skill produces professional decks at scale.

The skill's value lies in automation: define content structure once, apply design system programmatically, validate accessibility automatically, and export production-ready PowerPoint files in minutes instead of hours. This approach scales to 30+ slide decks without sacrificing quality or consistency.

Remember: presentations are communication tools, not art projects. Clarity, accessibility, and consistency matter more than novelty. Automate the mechanical work (layout, styling, validation) so presenters can focus on the creative work (storytelling, insights, persuasion). When presentations meet accessibility standards, they reach wider audiences. When design is consistent, the content shines. When generation is automated, teams iterate faster and deliver better results.