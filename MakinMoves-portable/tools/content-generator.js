/**
 * Content Generation Helper
 * Generates SEO-optimized content outlines, meta descriptions,
 * and structures for blog posts and affiliate content.
 */

const fs = require("fs");
const path = require("path");
const { marked } = require("marked");

class ContentGenerator {
  /**
   * Generate a full blog post outline optimized for SEO
   */
  generateArticleOutline(topic, targetKeyword, type = "guide") {
    const templates = {
      guide: this.guideTemplate(topic, targetKeyword),
      comparison: this.comparisonTemplate(topic, targetKeyword),
      listicle: this.listicleTemplate(topic, targetKeyword),
      review: this.reviewTemplate(topic, targetKeyword),
      howto: this.howToTemplate(topic, targetKeyword),
    };

    return templates[type] || templates.guide;
  }

  guideTemplate(topic, keyword) {
    return {
      title: `The Complete Guide to ${topic}`,
      meta_description: `Learn everything about ${topic}. This comprehensive guide covers ${keyword} with actionable tips, examples, and expert insights.`,
      target_keyword: keyword,
      word_count_target: "2000-3000",
      outline: [
        {
          h2: `What is ${topic}?`,
          notes: "Define clearly, use simple language, include keyword naturally",
        },
        {
          h2: `Why ${topic} Matters`,
          notes: "Benefits, statistics, real-world impact",
        },
        {
          h2: `How to Get Started with ${topic}`,
          subsections: [
            "Step 1: [First action]",
            "Step 2: [Second action]",
            "Step 3: [Third action]",
          ],
          notes: "Actionable steps, include screenshots/examples",
        },
        {
          h2: `Best Tools for ${topic}`,
          notes: "AFFILIATE OPPORTUNITY - link to tools with affiliate links",
        },
        {
          h2: `Common Mistakes to Avoid`,
          notes: "3-5 mistakes, builds trust and engagement",
        },
        {
          h2: `${topic} Tips from Experts`,
          notes: "Quote sources, link to authorities for backlink opportunities",
        },
        { h2: "FAQ", notes: "5+ questions targeting featured snippets" },
        { h2: "Conclusion", notes: "Summarize + CTA (email signup, product)" },
      ],
      seo_checklist: [
        "Keyword in title, H1, first paragraph, and 2-3 H2s",
        "Meta description under 160 chars with keyword",
        "Internal links to 3+ related articles",
        "External links to 2+ authority sources",
        "Alt text on all images with keyword variations",
        "Schema markup (FAQ, HowTo, or Article)",
        "Table of contents for posts over 1500 words",
      ],
    };
  }

  comparisonTemplate(topic, keyword) {
    return {
      title: `${topic}: Complete Comparison Guide`,
      meta_description: `Comparing the best options for ${keyword}. See features, pricing, pros & cons side by side.`,
      target_keyword: keyword,
      word_count_target: "2500-4000",
      outline: [
        { h2: "Quick Comparison Table", notes: "HTML table with key features, HIGH affiliate click potential" },
        { h2: "Our Top Pick", notes: "Best overall choice with affiliate link" },
        { h2: "Detailed Reviews", notes: "Each option gets H3 with pros/cons/pricing" },
        { h2: "How We Tested", notes: "Build credibility" },
        { h2: "Who Should Choose What", notes: "Match options to use cases" },
        { h2: "FAQ", notes: "vs queries people search for" },
      ],
    };
  }

  listicleTemplate(topic, keyword) {
    return {
      title: `Top 10 Best ${topic} [Current Year]`,
      meta_description: `Discover the ${keyword}. We tested and ranked the top options with real results.`,
      target_keyword: keyword,
      word_count_target: "2000-3500",
      outline: [
        { h2: "Our Top Picks at a Glance", notes: "Summary table" },
        { h2: "#1 - [Best Overall]", notes: "Most detailed review + affiliate link" },
        { h2: "#2-10", notes: "Each gets subsection with key features" },
        { h2: "How to Choose", notes: "Buying guide section" },
        { h2: "FAQ", notes: "Common questions" },
      ],
    };
  }

  reviewTemplate(topic, keyword) {
    return {
      title: `${topic} Review: Is It Worth It?`,
      meta_description: `Honest ${keyword} review after real testing. See features, pricing, alternatives, and our verdict.`,
      target_keyword: keyword,
      word_count_target: "1500-2500",
      outline: [
        { h2: "Quick Verdict", notes: "TL;DR with rating + affiliate CTA" },
        { h2: "What is it?", notes: "Overview" },
        { h2: "Key Features", notes: "Feature breakdown" },
        { h2: "Pricing", notes: "Plans comparison" },
        { h2: "Pros and Cons", notes: "Honest list" },
        { h2: "Alternatives", notes: "Link to comparison post" },
        { h2: "Final Verdict", notes: "Rating + CTA" },
      ],
    };
  }

  howToTemplate(topic, keyword) {
    return {
      title: `How to ${topic}: Step-by-Step Guide`,
      meta_description: `Learn how to ${keyword} with this easy step-by-step tutorial. Includes screenshots and pro tips.`,
      target_keyword: keyword,
      word_count_target: "1500-2500",
      outline: [
        { h2: "What You'll Need", notes: "Prerequisites + tool links (affiliate)" },
        { h2: "Step-by-Step Instructions", notes: "Numbered steps with images" },
        { h2: "Pro Tips", notes: "Advanced tips for better results" },
        { h2: "Troubleshooting", notes: "Common issues + solutions" },
        { h2: "FAQ", notes: "Related how-to questions" },
      ],
    };
  }

  /**
   * Save outline as a Markdown file ready for writing
   */
  saveAsMarkdown(outline, filename) {
    let md = `# ${outline.title}\n\n`;
    md += `> **Target Keyword:** ${outline.target_keyword}\n`;
    md += `> **Word Count Target:** ${outline.word_count_target}\n`;
    md += `> **Meta Description:** ${outline.meta_description}\n\n`;
    md += `---\n\n`;

    for (const section of outline.outline) {
      md += `## ${section.h2}\n\n`;
      if (section.subsections) {
        for (const sub of section.subsections) {
          md += `### ${sub}\n\n[Write content here]\n\n`;
        }
      } else {
        md += `[Write content here]\n\n`;
      }
      if (section.notes) {
        md += `<!-- NOTE: ${section.notes} -->\n\n`;
      }
    }

    if (outline.seo_checklist) {
      md += `---\n\n## SEO Checklist\n\n`;
      for (const item of outline.seo_checklist) {
        md += `- [ ] ${item}\n`;
      }
    }

    const outputPath = path.join(
      __dirname, "..", "projects", "content-affiliate", filename
    );
    fs.writeFileSync(outputPath, md);
    console.log(`Outline saved to: ${outputPath}`);
    return outputPath;
  }
}

module.exports = ContentGenerator;

if (require.main === module) {
  const gen = new ContentGenerator();
  const outline = gen.generateArticleOutline(
    "AI Writing Tools",
    "best AI writing tools",
    "listicle"
  );
  gen.saveAsMarkdown(outline, "sample-article-outline.md");
  console.log("\nSample outline generated!");
}
