# QuitWebApp

iPhone-first web app prototype for gamified smoking/vaping cessation.

## What is included
- Dense milestone cadence (daily through day 14, then frequent follow-up milestones)
- Multi-track progression: health, nicotine, money, resilience
- Currency selection for all savings/cost calculations
- Baseline nicotine estimated from daily smoking + cigarette strength (mild/medium/strong)
- Log-based NRT tracking in Crave tab (configure one product at a time, then log real use): gum, lozenge, spray, patch 24h, patch 16h
- Day-by-day nicotine trend chart (actual logs + taper plan projection)
- Adaptive nicotine milestones (taper mode when nicotine > 0, abstinence mode when nicotine reaches 0)
- Level + XP economy with fast early progression
- Craving rescue mini-loop (90-second urge-surf timer)
- Daily quests + bounded mystery rewards + streak shields
- Research docs and strategy docs:
  - `RESEARCH.md`
  - `GAME_STRATEGY.md`

## Files
- `index.html`
- `styles.css`
- `app.js`
- `RESEARCH.md`
- `GAME_STRATEGY.md`

## Run locally
Open `index.html` in browser.

## Deploy to GitHub Pages (folder-based)

### Option A (simple)
1. Push repo to GitHub.
2. In repository settings, open **Pages**.
3. Choose deployment source as branch and folder (for example, `main` + `/QuitWebApp`).
4. Save, then wait for publish.

### Option B (GitHub Actions)
Already included: `.github/workflows/deploy_quitwebapp.yml`

1. In GitHub repository settings, enable **Pages** with source set to **GitHub Actions**.
2. Push changes to `main`.
3. Workflow deploys `QuitWebApp` automatically.

## Notes
- Data is stored in `localStorage` on-device.
- This app is educational/supportive and not a medical device.
