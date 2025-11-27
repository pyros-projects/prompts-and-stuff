# 🔧 Scripts

**The "I have a day job" section**

Utility scripts that solve real problems. Cloud management, automation, and whatever else accumulates when you refuse to do the same task manually twice.

---

## Available Scripts

### [Azure](./azure/)

PowerShell scripts for Azure cloud management.

| Script | Purpose |
|--------|---------|
| [`ExportAPIM_interactive.ps1`](./azure/ExportAPIM_interactive.ps1) | Export Azure API Management instances to JSON |

---

## Folder Structure

```
scripts/
├── README.md           # This file
└── azure/
    ├── README.md       # Azure scripts documentation
    └── ExportAPIM_interactive.ps1
```

---

## Philosophy

- **If I needed it twice, it goes here** — No more hunting through Slack history for that one command
- **Interactive AND automated** — Explore with prompts, script with flags
- **Documented for future-me** — Who will have forgotten everything in 3 months

---

## Contributing

Have a useful script? PRs welcome.

**Guidelines:**
- Scripts should be self-contained with clear documentation
- Include installation instructions for dependencies
- Provide both interactive and command-line modes where applicable
- Handle errors gracefully
- Comment your code (future-you will thank present-you)
