# Procurello

An agentic procurement & accounts payable concept prototype. Static HTML demo showing how AI-powered procurement could work for casual users (researchers, lab managers), executive sponsors, and AP operations teams.

## What's in this repo

```
├── index.html                          # Marketing landing page (entry point)
├── requester-home.html                 # Requester command center (Jamie)
├── leader-dashboard.html               # Leader command center (Dr. Reyes)
├── ap-operations.html                  # AP operations command center (David)
├── catalog-guided-buying.html          # Scenario: catalog buying
├── guided-buying-concept.html          # Scenario: non-catalog services
├── invoice-guided-buying.html          # Scenario: invoice & receiving
├── contract-quote-guided-buying.html   # Scenario: supplier contract
├── requirements.md                     # Implementation spec for Replit / dev team
└── images/
    ├── README.md                       # Image download instructions
    └── download-images.sh              # Script to populate product photos
```

## Running locally

Open `index.html` in any browser. No server or build step required.

If serving via Python for local testing:
```bash
python3 -m http.server 8000
# Open http://localhost:8000
```

## Before deploying

The catalog page references three product images that aren't checked into the repo. Run the download script first:

```bash
bash images/download-images.sh
```

Or download manually — see `images/README.md` for the source URLs.

## Personas

- **Jamie Mendez** — Lab Manager (casual requester)
- **Dr. Sarah Reyes** — Associate Dean (leader/approver)
- **David Kwan** — AP Operations Manager

## Status

Conceptual prototype for demonstration purposes. Not affiliated with any vendor. See `requirements.md` for the production implementation roadmap.
