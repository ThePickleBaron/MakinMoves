# MakinMoves Cover Image Specifications
**Created:** 2026-03-29
**Brand:** ExsituInnovations
**Master Colors:** Navy (#1B2A4A), Coral (#FF6B6B), White (#FFFFFF)

---

## Overview & Design Principles

All covers follow a 1280×720 px (16:9) specification optimized for Gumroad product pages and thumbnail auto-cropping. The **safe zone** (center 720×720 px) contains all critical text and branding elements to survive Gumroad's square crop for listings.

### Key Requirements
- **Dimensions:** 1280 × 720 px (16:9 widescreen)
- **Safe Zone:** Center 720×720 px (all essential text/logos must be here)
- **Edge Zones:** Left/right 280 px buffers (may be cropped in thumbnails)
- **Text Hierarchy:** Title → Subtitle → Price → Brand
- **Font Stack:** Primary (titles) = Montserrat Bold; Secondary (subtitles) = Open Sans; Badges = Roboto Mono

---

## PRODUCT 1: AI Prompt Pack ($24)

### Overview
A clean, modern design emphasizing AI capabilities, conversation flow, and time-saving benefits. The design uses a subtle chat bubble motif with gradient elements.

### Color Palette
| Element | Color | Hex Code | Usage |
|---------|-------|----------|-------|
| Background | Navy Gradient | #1B2A4A → #0F1620 | Full background (left to right fade) |
| Title Accent | Coral | #FF6B6B | Underline, highlights |
| Text Primary | White | #FFFFFF | All main text |
| Chat Bubble | Coral (30% opacity) | #FF6B6B4D | Background shapes |
| Accent Light | Navy Light | #2D3E5F | Secondary elements |

### Layout Grid (1280 × 720)
```
┌─────────────────────────────────────────────┐
│ EDGE BUFFER (280px)     SAFE ZONE (720px)    │
│                                               │
│  ╔═══════════════════════════════════════╗   │
│  ║                                       ║   │
│  ║     CHAT BUBBLE ACCENT (top-right)    ║   │
│  ║     [Coral circles, 80px diameter]    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  TITLE ZONE (y: 120px)       ║    ║   │
│  ║  ║  "50 AI Prompts for          ║    ║   │
│  ║  ║   Freelancers"               ║    ║   │
│  ║  ║  [Coral underline: 200px]    ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  SUBTITLE ZONE (y: 280px)    ║    ║   │
│  ║  ║  "Land Clients. Close Deals. ║    ║   │
│  ║  ║   Save 10+ Hours/Week."      ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  PRICE BADGE (y: 420px)      ║    ║   │
│  ║  ║  "$24"                        ║    ║   │
│  ║  ║  [Navy pill, 120 × 60px]     ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  BRAND (y: 630px)            ║    ║   │
│  ║  ║  ExsituInnovations           ║    ║   │
│  ║  ║  [8pt text, subtle]          ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ╚═══════════════════════════════════════╝   │
└─────────────────────────────────────────────┘
```

### Text Specifications

#### Title
- **Text:** "50 AI Prompts for Freelancers"
- **Font:** Montserrat Bold, 64 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640 (center), y: 160
- **Line Height:** 1.2
- **Letter Spacing:** -1px

#### Title Underline
- **Element:** Solid line under title
- **Color:** #FF6B6B (Coral)
- **Dimensions:** 200 px wide × 4 px tall
- **Position:** x: 540, y: 240

#### Subtitle
- **Text:** "Land Clients. Close Deals. Save 10+ Hours/Week."
- **Font:** Open Sans Regular, 28 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640, y: 310
- **Line Height:** 1.4
- **Max Width:** 600 px

#### Price Badge
- **Text:** "$24"
- **Font:** Roboto Mono Bold, 44 px
- **Background Color:** #2D3E5F (Navy Light, 80% opacity)
- **Text Color:** #FF6B6B (Coral)
- **Border:** 2 px #FF6B6B
- **Padding:** 16 px vertical, 32 px horizontal
- **Position:** x: 640 (center), y: 430
- **Border Radius:** 30 px (pill shape)

#### Brand/Footer
- **Text:** "ExsituInnovations"
- **Font:** Open Sans Bold, 14 px
- **Color:** #FFFFFF (70% opacity)
- **Alignment:** Center
- **Position:** x: 640, y: 680

### Visual Elements

#### Chat Bubble Accent (Top Right)
- **Type:** 2-3 overlapping circles representing AI conversation flow
- **Colors:**
  - Large circle: #FF6B6B (50% opacity)
  - Medium circle: #FF6B6B (35% opacity)
  - Small circle: #FF6B6B (20% opacity)
- **Positions:**
  - Large: x: 1000, y: 80, diameter: 120px
  - Medium: x: 1080, y: 140, diameter: 80px
  - Small: x: 1120, y: 100, diameter: 50px

#### Background Gradient
- **Type:** Linear gradient, left to right
- **Start Color:** #1B2A4A (Navy)
- **End Color:** #0F1620 (Navy Dark)
- **Angle:** 90° (left to right)

### Safety Notes
- **Safe Zone (Center 720×720):** All text elements, price badge, title underline, brand
- **Risk Zone (Edges):** Chat bubble accents may be partially cropped; position outside safe zone intentionally
- **Gumroad Thumbnail Impact:** When cropped to square, center title and price remain fully visible

---

## PRODUCT 2: Notion Template ($39)

### Overview
A professional dashboard design emphasizing Notion's UI patterns and business organization. Features subtle dashboard grid elements and a dashboard preview aesthetic.

### Color Palette
| Element | Color | Hex Code | Usage |
|---------|-------|----------|-------|
| Background | Navy | #1B2A4A | Full background |
| Primary Accent | Coral | #FF6B6B | Highlights, buttons, grid lines |
| Text Primary | White | #FFFFFF | All main text |
| Dashboard Grid | Coral (15% opacity) | #FF6B6B26 | Grid lines, subtle structure |
| UI Elements | Navy Light | #2D3E5F | Card backgrounds, panels |

### Layout Grid (1280 × 720)
```
┌─────────────────────────────────────────────┐
│ EDGE BUFFER (280px)     SAFE ZONE (720px)    │
│                                               │
│  ╔═══════════════════════════════════════╗   │
│  ║                                       ║   │
│  ║  [Grid Pattern Background]            ║   │
│  ║  [Coral 15% opacity grid lines]       ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  TITLE ZONE (y: 100px)       ║    ║   │
│  ║  ║  "Freelance Business OS"      ║    ║   │
│  ║  ║  [Coral underline: 240px]    ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  SUBTITLE ZONE (y: 260px)    ║    ║   │
│  ║  ║  "Invoices. Clients.          ║    ║   │
│  ║  ║   Projects. One Template."    ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  DASHBOARD PREVIEW AREA       ║    ║   │
│  ║  ║  [Small UI card mockups]      ║    ║   │
│  ║  ║  (y: 380-460px)               ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  PRICE BADGE (y: 500px)      ║    ║   │
│  ║  ║  "$39"                        ║    ║   │
│  ║  ║  [Coral pill]                 ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  BRAND (y: 630px)            ║    ║   │
│  ║  ║  ExsituInnovations           ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ╚═══════════════════════════════════════╝   │
└─────────────────────────────────────────────┘
```

### Text Specifications

#### Title
- **Text:** "Freelance Business OS"
- **Font:** Montserrat Bold, 68 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640, y: 150
- **Line Height:** 1.2
- **Letter Spacing:** -1.5px

#### Title Underline
- **Element:** Solid line under title
- **Color:** #FF6B6B (Coral)
- **Dimensions:** 240 px wide × 4 px tall
- **Position:** x: 520, y: 220

#### Subtitle
- **Text:** "Invoices. Clients. Projects. One Template."
- **Font:** Open Sans Regular, 26 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640, y: 300
- **Line Height:** 1.4
- **Max Width:** 600 px

#### Dashboard Preview Text (Optional Micro-Labels)
- **Elements:** Small labels in dashboard preview area
- **Font:** Open Sans, 10 px
- **Color:** #FFFFFF (60% opacity)
- **Examples:** "Invoices", "Clients", "Projects"
- **Positions:** Distributed across preview area (y: 380-460)

#### Price Badge
- **Text:** "$39"
- **Font:** Roboto Mono Bold, 44 px
- **Background Color:** #FF6B6B (Coral)
- **Text Color:** #FFFFFF
- **Padding:** 16 px vertical, 32 px horizontal
- **Position:** x: 640 (center), y: 500
- **Border Radius:** 30 px (pill shape)

#### Brand/Footer
- **Text:** "ExsituInnovations"
- **Font:** Open Sans Bold, 14 px
- **Color:** #FFFFFF (70% opacity)
- **Alignment:** Center
- **Position:** x: 640, y: 680

### Visual Elements

#### Dashboard Preview Cards
- **Type:** 3-4 small rectangular card mockups arranged in a 2×2 grid
- **Card Dimensions:** 120 × 100 px each
- **Background:** #2D3E5F (Navy Light)
- **Border:** 1 px #FF6B6B (Coral, 30% opacity)
- **Positions:**
  - Top-left: x: 440, y: 380
  - Top-right: x: 600, y: 380
  - Bottom-left: x: 440, y: 450
  - Bottom-right: x: 600, y: 450
- **Interior:** Simple horizontal lines (#FFFFFF, 20% opacity) to suggest content

#### Grid Pattern Background
- **Type:** Subtle grid overlay
- **Grid Size:** 40 × 40 px squares
- **Color:** #FF6B6B (15% opacity)
- **Coverage:** Full 1280 × 720 area, mostly visible in edges

### Safety Notes
- **Safe Zone (Center 720×720):** Title, subtitle, dashboard preview cards, price badge, brand
- **Risk Zone (Edges):** Grid pattern background may be cropped
- **Gumroad Thumbnail Impact:** All essential UI mockups and text remain visible when cropped to square

---

## PRODUCT 3: Bundle ($49)

### Overview
A value-focused design combining visual elements from both products while emphasizing savings and bundle benefits. Features both chat bubbles and dashboard elements plus a prominent "Save 22%" badge.

### Color Palette
| Element | Color | Hex Code | Usage |
|---------|-------|----------|-------|
| Background | Navy Gradient | #1B2A4A → #0F1620 | Full background |
| Primary Accent | Coral | #FF6B6B | Highlights, savings badge |
| Text Primary | White | #FFFFFF | All main text |
| Savings Badge | Coral (bright) | #FF6B6B | Savings callout background |
| Savings Text | Navy | #1B2A4A | Savings callout text |

### Layout Grid (1280 × 720)
```
┌─────────────────────────────────────────────┐
│ EDGE BUFFER (280px)     SAFE ZONE (720px)    │
│                                               │
│  ╔═══════════════════════════════════════╗   │
│  ║                                       ║   │
│  ║  [Chat Bubble Accent - Top Right]     ║   │
│  ║  [Coral circles]                      ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  TITLE ZONE (y: 100px)       ║    ║   │
│  ║  ║  "The Freelance Starter Kit"  ║    ║   │
│  ║  ║  [Coral underline: 280px]    ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  SUBTITLE ZONE (y: 240px)    ║    ║   │
│  ║  ║  "Prompts + Template —         ║    ║   │
│  ║  ║   Everything You Need"        ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  SAVINGS BADGE (y: 360px)    ║    ║   │
│  ║  ║  "Save 22%"                   ║    ║   │
│  ║  ║  [Coral circle, 80px]        ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  PRICE BADGE (y: 480px)      ║    ║   │
│  ║  ║  "$49 (was $63)"              ║    ║   │
│  ║  ║  [Navy pill]                  ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ║  ╔═══════════════════════════════╗    ║   │
│  ║  ║  BRAND (y: 630px)            ║    ║   │
│  ║  ║  ExsituInnovations           ║    ║   │
│  ║  ╚═══════════════════════════════╝    ║   │
│  ║                                       ║   │
│  ╚═══════════════════════════════════════╝   │
└─────────────────────────────────────────────┘
```

### Text Specifications

#### Title
- **Text:** "The Freelance Starter Kit"
- **Font:** Montserrat Bold, 64 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640, y: 150
- **Line Height:** 1.2
- **Letter Spacing:** -1px

#### Title Underline
- **Element:** Solid line under title
- **Color:** #FF6B6B (Coral)
- **Dimensions:** 280 px wide × 4 px tall
- **Position:** x: 500, y: 220

#### Subtitle
- **Text:** "Prompts + Template — Everything You Need"
- **Font:** Open Sans Regular, 28 px
- **Color:** #FFFFFF
- **Alignment:** Center
- **Position:** x: 640, y: 280
- **Line Height:** 1.4
- **Max Width:** 620 px

#### Savings Badge Text
- **Text:** "Save 22%"
- **Font:** Montserrat Bold, 36 px
- **Color:** #1B2A4A (Navy)
- **Alignment:** Center
- **Position:** x: 640, y: 370
- **Background:** Circular (#FF6B6B), diameter 100 px

#### Price Badge
- **Text:** "$49 (was $63)"
- **Font:** Roboto Mono Bold, 40 px
- **Background Color:** #2D3E5F (Navy Light)
- **Text Color:** #FF6B6B (Coral)
- **Border:** 2 px #FF6B6B
- **Padding:** 16 px vertical, 32 px horizontal
- **Position:** x: 640 (center), y: 480
- **Border Radius:** 30 px (pill shape)

#### Brand/Footer
- **Text:** "ExsituInnovations"
- **Font:** Open Sans Bold, 14 px
- **Color:** #FFFFFF (70% opacity)
- **Alignment:** Center
- **Position:** x: 640, y: 680

### Visual Elements

#### Chat Bubble Accent (Top Right)
- **Type:** 2 overlapping circles (from Product 1 design)
- **Colors:**
  - Large: #FF6B6B (40% opacity)
  - Small: #FF6B6B (25% opacity)
- **Positions:**
  - Large: x: 1000, y: 80, diameter: 100px
  - Small: x: 1070, y: 120, diameter: 60px

#### Savings Badge Circle
- **Type:** Solid circle with prominent badge styling
- **Background Color:** #FF6B6B (Coral)
- **Diameter:** 100 px
- **Center:** x: 640, y: 370
- **Box Shadow:** 0 8px 24px rgba(255, 107, 107, 0.3)

#### Background Gradient
- **Type:** Linear gradient, left to right
- **Start Color:** #1B2A4A (Navy)
- **End Color:** #0F1620 (Navy Dark)
- **Angle:** 90°

### Safety Notes
- **Safe Zone (Center 720×720):** Title, subtitle, savings badge circle, price badge, brand
- **Risk Zone (Edges):** Chat bubble accents may be partially cropped; intentional design choice
- **Gumroad Thumbnail Impact:** All critical elements (savings badge, price, title) survive square crop

---

## Implementation Notes

### Font Resources
All fonts available from Google Fonts (free):
- **Montserrat Bold:** https://fonts.google.com/specimen/Montserrat
- **Open Sans Regular/Bold:** https://fonts.google.com/specimen/Open+Sans
- **Roboto Mono Bold:** https://fonts.google.com/specimen/Roboto+Mono

### Color Hex Reference (Quick Copy)
```
Navy:          #1B2A4A
Navy Dark:     #0F1620
Navy Light:    #2D3E5F
Coral:         #FF6B6B
White:         #FFFFFF
```

### Design Tool Guidance
These specs are optimized for:
- **Figma:** Set artboard to 1280 × 720 px; use community plugins for guides
- **Canva:** Use custom 1280×720 template; snap elements to grid
- **Adobe Design:** Create multi-artboard file with one per product
- **SVG/Code:** Use this spec as precise coordinate reference

### Gumroad Thumbnail Cropping Behavior
Gumroad crops product covers to square (720 × 720 px) from the center when displaying in product listings. The safe zone specification ensures all critical text, pricing, and brand elements remain visible in thumbnails.

**Safe Zone = Center 720×720 px (x: 280–1000, y: 0–720)**

---

## Version History
- **v1.0** (2026-03-29): Initial specification for 3-product line. All specs finalized and ready for design/development.
