/**
 * MakinMoves Trading Bot Template
 * A basic framework for building trading bots.
 * START WITH PAPER TRADING ONLY - never risk real money until thoroughly tested.
 *
 * Supports: Alpaca (stocks, free paper trading) and can be extended for crypto.
 */

const axios = require("axios");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", "..", ".env") });

class TradingBot {
  constructor(config = {}) {
    this.name = config.name || "MakinMoves Bot";
    this.paperTrading = config.paperTrading !== false; // Default: paper trading ON
    this.maxPositionSize = config.maxPositionSize || 100; // Max $ per trade
    this.stopLossPercent = config.stopLossPercent || 5;
    this.takeProfitPercent = config.takeProfitPercent || 10;
    this.trades = [];

    // Alpaca config (paper trading)
    this.alpacaBaseUrl = this.paperTrading
      ? "https://paper-api.alpaca.markets"
      : process.env.ALPACA_BASE_URL;
    this.alpacaHeaders = {
      "APCA-API-KEY-ID": process.env.ALPACA_API_KEY,
      "APCA-API-SECRET-KEY": process.env.ALPACA_SECRET,
    };
  }

  // ── Market Data ─────────────────────────────────────
  async getQuote(symbol) {
    try {
      const { data } = await axios.get(
        `https://data.alpaca.markets/v2/stocks/${symbol}/quotes/latest`,
        { headers: this.alpacaHeaders }
      );
      return data.quote;
    } catch (err) {
      console.error(`Quote error for ${symbol}:`, err.message);
      return null;
    }
  }

  async getBars(symbol, timeframe = "1Day", limit = 30) {
    try {
      const { data } = await axios.get(
        `https://data.alpaca.markets/v2/stocks/${symbol}/bars`,
        {
          headers: this.alpacaHeaders,
          params: { timeframe, limit },
        }
      );
      return data.bars;
    } catch (err) {
      console.error(`Bars error for ${symbol}:`, err.message);
      return [];
    }
  }

  // ── Simple Indicators ───────────────────────────────
  sma(prices, period) {
    if (prices.length < period) return null;
    const slice = prices.slice(-period);
    return slice.reduce((sum, p) => sum + p, 0) / period;
  }

  rsi(prices, period = 14) {
    if (prices.length < period + 1) return null;
    let gains = 0, losses = 0;
    for (let i = prices.length - period; i < prices.length; i++) {
      const change = prices[i] - prices[i - 1];
      if (change > 0) gains += change;
      else losses += Math.abs(change);
    }
    const avgGain = gains / period;
    const avgLoss = losses / period;
    if (avgLoss === 0) return 100;
    const rs = avgGain / avgLoss;
    return 100 - 100 / (1 + rs);
  }

  // ── Trading Logic (Override this!) ──────────────────
  async evaluate(symbol) {
    const bars = await this.getBars(symbol);
    if (!bars || bars.length < 20) return { signal: "hold", reason: "Insufficient data" };

    const closes = bars.map((b) => b.c);
    const sma10 = this.sma(closes, 10);
    const sma20 = this.sma(closes, 20);
    const currentRSI = this.rsi(closes);
    const currentPrice = closes[closes.length - 1];

    // Simple SMA crossover + RSI strategy
    if (sma10 > sma20 && currentRSI < 70) {
      return {
        signal: "buy",
        reason: `SMA10 (${sma10.toFixed(2)}) > SMA20 (${sma20.toFixed(2)}), RSI: ${currentRSI.toFixed(1)}`,
        price: currentPrice,
      };
    } else if (sma10 < sma20 || currentRSI > 80) {
      return {
        signal: "sell",
        reason: `SMA10 (${sma10.toFixed(2)}) < SMA20 (${sma20.toFixed(2)}), RSI: ${currentRSI.toFixed(1)}`,
        price: currentPrice,
      };
    }

    return {
      signal: "hold",
      reason: `No clear signal. SMA10: ${sma10.toFixed(2)}, SMA20: ${sma20.toFixed(2)}, RSI: ${currentRSI.toFixed(1)}`,
      price: currentPrice,
    };
  }

  // ── Order Execution ─────────────────────────────────
  async placeOrder(symbol, side, qty) {
    if (!this.paperTrading) {
      console.log("WARNING: Live trading is enabled! Double-check before proceeding.");
    }

    try {
      const { data } = await axios.post(
        `${this.alpacaBaseUrl}/v2/orders`,
        {
          symbol,
          qty: String(qty),
          side,
          type: "market",
          time_in_force: "day",
        },
        { headers: this.alpacaHeaders }
      );

      const trade = {
        id: data.id,
        symbol,
        side,
        qty,
        status: data.status,
        timestamp: new Date().toISOString(),
      };
      this.trades.push(trade);
      console.log(`Order placed: ${side} ${qty} ${symbol} (${data.status})`);
      return trade;
    } catch (err) {
      console.error(`Order error:`, err.response?.data || err.message);
      return null;
    }
  }

  // ── Account Info ────────────────────────────────────
  async getAccount() {
    try {
      const { data } = await axios.get(`${this.alpacaBaseUrl}/v2/account`, {
        headers: this.alpacaHeaders,
      });
      return {
        equity: data.equity,
        cash: data.cash,
        buying_power: data.buying_power,
        portfolio_value: data.portfolio_value,
      };
    } catch (err) {
      console.error("Account error:", err.message);
      return null;
    }
  }

  // ── Run the bot ─────────────────────────────────────
  async run(symbols = ["AAPL", "MSFT", "GOOGL"]) {
    console.log(`\n=== ${this.name} ===`);
    console.log(`Mode: ${this.paperTrading ? "PAPER TRADING" : "LIVE"}`);
    console.log(`Symbols: ${symbols.join(", ")}\n`);

    const account = await this.getAccount();
    if (account) {
      console.log(`Account: $${account.equity} equity, $${account.cash} cash\n`);
    }

    for (const symbol of symbols) {
      const signal = await this.evaluate(symbol);
      console.log(`${symbol}: ${signal.signal.toUpperCase()} - ${signal.reason}`);

      if (signal.signal === "buy" && signal.price) {
        const qty = Math.floor(this.maxPositionSize / signal.price);
        if (qty > 0) {
          console.log(`  -> Would buy ${qty} shares at ~$${signal.price}`);
          // Uncomment to actually execute:
          // await this.placeOrder(symbol, 'buy', qty);
        }
      }
    }
  }
}

module.exports = TradingBot;

if (require.main === module) {
  const bot = new TradingBot({ name: "MakinMoves Demo Bot", paperTrading: true });
  bot.run(["AAPL", "MSFT", "TSLA", "AMZN"]).then(() => {
    console.log("\nDone. Remember: Always paper trade first!");
  });
}
