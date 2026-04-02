/**
 * Niche & Market Research Tool
 * Helps identify profitable niches, analyze competition, and find opportunities.
 */

const axios = require("axios");
const cheerio = require("cheerio");
const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env") });

class NicheResearcher {
  /**
   * Analyze a niche for passive income potential
   */
  async analyzeNiche(niche) {
    console.log(`\nAnalyzing niche: "${niche}"\n`);

    const report = {
      niche,
      analyzed_at: new Date().toISOString(),
      digital_product_ideas: this.generateProductIdeas(niche),
      saas_ideas: this.generateSaaSIdeas(niche),
      content_ideas: this.generateContentIdeas(niche),
      monetization_strategies: this.getMonetizationStrategies(niche),
      platforms: this.getRelevantPlatforms(niche),
    };

    // Save report
    const filename = `niche-${niche.replace(/\s+/g, "-").toLowerCase()}-${Date.now()}.json`;
    const outputPath = path.join(__dirname, "..", "data", filename);
    fs.writeFileSync(outputPath, JSON.stringify(report, null, 2));
    console.log(`Report saved to: ${outputPath}`);

    return report;
  }

  generateProductIdeas(niche) {
    return [
      `${niche} Starter Guide (PDF/eBook) - $9-29`,
      `${niche} Templates Pack - $19-49`,
      `${niche} Checklist/Cheat Sheet - $5-15`,
      `${niche} Video Course (mini) - $29-99`,
      `${niche} Notion/Spreadsheet Templates - $9-29`,
      `${niche} Printable Planner/Tracker - $5-19`,
      `${niche} Prompt Pack (AI prompts) - $9-29`,
      `${niche} Swipe File / Examples Collection - $19-49`,
    ];
  }

  generateSaaSIdeas(niche) {
    return [
      `${niche} Calculator/Estimator Tool`,
      `${niche} Directory/Listing Site`,
      `${niche} Comparison Tool`,
      `${niche} Scheduling/Booking Tool`,
      `${niche} Dashboard/Analytics`,
      `${niche} API/Data Service`,
    ];
  }

  generateContentIdeas(niche) {
    return [
      `"Best ${niche} Tools" (affiliate roundup)`,
      `"${niche} for Beginners" (evergreen guide)`,
      `"${niche} vs [Alternative]" (comparison)`,
      `"How to [Common Task] with ${niche}" (tutorial)`,
      `"${niche} Templates" (lead magnet + affiliate)`,
      `"${niche} Mistakes to Avoid" (engagement post)`,
      `"${niche} Cost Breakdown" (high-intent keyword)`,
      `"${niche} Case Study" (authority builder)`,
    ];
  }

  getMonetizationStrategies(niche) {
    return {
      quick_wins: [
        "Sell templates/guides on Gumroad (0 upfront cost)",
        "Create Canva templates for Etsy",
        "Offer freelance services while building products",
        "Affiliate marketing for existing tools",
      ],
      medium_term: [
        "Build email list with free lead magnet",
        "Launch small SaaS tool ($9-29/mo)",
        "Create video course on Udemy/Skillshare",
        "Start niche blog with SEO content",
      ],
      long_term: [
        "Membership/community site",
        "Premium SaaS product",
        "Sponsored content deals",
        "White-label solutions",
      ],
    };
  }

  getRelevantPlatforms(niche) {
    return {
      digital_products: [
        { name: "Gumroad", url: "https://gumroad.com", fee: "10% flat" },
        { name: "Etsy", url: "https://etsy.com", fee: "6.5% + listing" },
        {
          name: "Payhip",
          url: "https://payhip.com",
          fee: "5% (free plan)",
        },
        {
          name: "Lemon Squeezy",
          url: "https://lemonsqueezy.com",
          fee: "5% + payment",
        },
      ],
      courses: [
        { name: "Udemy", url: "https://udemy.com", fee: "37-97% rev share" },
        {
          name: "Skillshare",
          url: "https://skillshare.com",
          fee: "per minute watched",
        },
        { name: "Teachable", url: "https://teachable.com", fee: "$39+/mo" },
      ],
      content: [
        { name: "Medium", url: "https://medium.com", fee: "Partner program" },
        { name: "Substack", url: "https://substack.com", fee: "10% on paid" },
        { name: "WordPress", url: "https://wordpress.org", fee: "Hosting cost" },
      ],
      affiliate: [
        { name: "Amazon Associates", commission: "1-10%" },
        { name: "ShareASale", commission: "Varies" },
        { name: "Impact", commission: "Varies" },
        { name: "PartnerStack", commission: "SaaS focused" },
      ],
    };
  }
}

module.exports = NicheResearcher;

if (require.main === module) {
  const researcher = new NicheResearcher();
  const niche = process.argv.slice(2).join(" ") || "productivity";
  researcher.analyzeNiche(niche).then((r) => {
    console.log("\n=== Quick Wins ===");
    r.monetization_strategies.quick_wins.forEach((s) => console.log(`  - ${s}`));
  });
}
