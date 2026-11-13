# Jio Platforms IPO Dashboard (Power BI)

An interactive Power BI dashboard comparing India's biggest IPOs, with Jio Platforms
(listed 28 Oct 2026) as the main case study.

## What it does
- "What if I invested?" tool: pick a company and number of lots, and see the listing-day gain
- Biggest IPOs by issue size, with Jio highlighted
- KPI cards: total IPOs, total raised, average listing gain, % listed above issue price

## Jio at a glance
| Metric | Value |
|---|---|
| Issue price | ₹1,119 |
| Lot size | 12 shares (₹13,428) |
| Listing price | ₹1,358 (+21.4%) |
| Gain per lot | ₹2,868 |

## Tools
Power BI Desktop, Power Query, DAX, custom theme

## Files
- `jio_ipo.pbix`: the dashboard
- `Fact_IPO.csv`, `Fact_Subscription_Daily.csv`: data
- `02_Measures.dax`: DAX measures
- `03_IPO_Theme.json`: dark theme

## Demo
[Watch the screen recording](PASTE-YOUR-VIDEO-LINK-HERE)

## Data note
Jio figures were researched in Oct 2026. Subscription multiples vary by source,
so verify on NSE/BSE. Other IPO rows were entered manually and should be verified
against NSE/BSE before relying on them.

*For learning purposes only. Not investment advice.*
