/**
 * MakinMoves Web Scraper
 * Multipurpose scraper for market research, competitor analysis, and data collection.
 * Uses Selenium (Docker) or Puppeteer (local) for dynamic pages.
 */

const axios = require("axios");
const cheerio = require("cheerio");
const { parse } = require("csv-stringify/sync");
const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env") });

class Scraper {
  constructor() {
    this.results = [];
    this.headers = {
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    };
  }

  // Simple HTTP scrape for static pages
  async scrapeStatic(url, selectors = {}) {
    try {
      const { data } = await axios.get(url, { headers: this.headers });
      const $ = cheerio.load(data);
      const result = { url, scraped_at: new Date().toISOString() };

      for (const [key, selector] of Object.entries(selectors)) {
        const elements = $(selector);
        result[key] =
          elements.length > 1
            ? elements.map((_, el) => $(el).text().trim()).get()
            : elements.text().trim();
      }

      this.results.push(result);
      return result;
    } catch (err) {
      console.error(`Error scraping ${url}:`, err.message);
      return null;
    }
  }

  // Scrape Google search results (for keyword/niche research)
  async searchGoogle(query, numResults = 10) {
    // Use Brave Search API if key is available, otherwise basic scrape
    if (process.env.BRAVE_API_KEY) {
      return this.bravSearch(query, numResults);
    }
    console.log("Tip: Set BRAVE_API_KEY in .env for better search results");
    console.log(`Searching for: ${query}`);
    return [];
  }

  async braveSearch(query, count = 10) {
    try {
      const { data } = await axios.get(
        "https://api.search.brave.com/res/v1/web/search",
        {
          params: { q: query, count },
          headers: {
            "X-Subscription-Token": process.env.BRAVE_API_KEY,
            Accept: "application/json",
          },
        }
      );
      return (data.web?.results || []).map((r) => ({
        title: r.title,
        url: r.url,
        description: r.description,
      }));
    } catch (err) {
      console.error("Brave Search error:", err.message);
      return [];
    }
  }

  // Scrape product listings (Etsy, Gumroad, etc.) for market research
  async scrapeMarketplace(url) {
    return this.scrapeStatic(url, {
      titles: ".listing-title, .product-card h2, h3.product-name",
      prices: ".price, .product-price, [data-price]",
      ratings: ".rating, .stars, [data-rating]",
    });
  }

  // Export results to CSV
  exportCSV(filename) {
    if (this.results.length === 0) {
      console.log("No results to export");
      return;
    }
    const outputPath = path.join(__dirname, "..", "data", filename);
    const csv = parse(this.results, { header: true });
    fs.writeFileSync(outputPath, csv);
    console.log(`Exported ${this.results.length} results to ${outputPath}`);
    return outputPath;
  }

  // Export results to JSON
  exportJSON(filename) {
    const outputPath = path.join(__dirname, "..", "data", filename);
    fs.writeFileSync(outputPath, JSON.stringify(this.results, null, 2));
    console.log(`Exported ${this.results.length} results to ${outputPath}`);
    return outputPath;
  }
}

module.exports = Scraper;

// CLI usage
if (require.main === module) {
  const scraper = new Scraper();
  const [, , command, ...args] = process.argv;

  switch (command) {
    case "search":
      scraper.searchGoogle(args.join(" ")).then((r) => console.log(r));
      break;
    case "url":
      scraper.scrapeStatic(args[0]).then((r) => console.log(r));
      break;
    default:
      console.log("Usage:");
      console.log("  node scraper.js search <query>");
      console.log("  node scraper.js url <url>");
  }
}
