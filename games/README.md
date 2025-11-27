# 🎮 Games

**Interactive games designed to be played with AI assistants**

This folder contains game prompts that turn LLM conversations into structured, playful experiences. Each game has rules, progression mechanics, and defined win/lose conditions.

---

## Available Games

### [Essence — The Design Guessing Game](./essence/)

*"What if this person WAS a website? A poster? A generative art piece?"*

A guessing game where the AI transforms famous personalities into absurdist design artifacts. The player guesses who it is based purely on vibe, visual language, and design choices.

| Feature | Description |
|---------|-------------|
| **Rounds** | 10 rounds with progressive difficulty |
| **Mechanics** | 3 guesses + 3 hints per round |
| **Output Formats** | Websites, posters, algorithmic art, GIFs, presentations, documents |
| **Customization** | People pool, design constraints, spice level |

**The magic:** The mismatch IS the comedy. Politicians become landing pages. Philosophers become error states. Chefs become form validation. Scientists become loading animations.

**Examples:**
- Donald Trump as aggressive gold gradients fighting for dominance
- Bob Ross as the softest 404 page ever made
- Kafka as an endless CAPTCHA that asks impossible questions

**To play:** Paste [`essence/prompt.md`](./essence/prompt.md) into Claude and say *"Let's play Essence"*

---

## Folder Contents

```
games/
├── README.md           # This file
└── essence/
    ├── prompt.md       # The game prompt (paste this into Claude)
    ├── example1.png    # Screenshot of example gameplay
    └── example2.png    # Screenshot of example gameplay
```

---

## Design Philosophy

Games make better interfaces than open-ended requests because:

1. **Constraints breed creativity** — Rules force the AI to be inventive within boundaries
2. **Structure enables surprise** — The tension between format and content produces unexpected results
3. **Progress creates engagement** — Rounds, scores, and difficulty curves make interactions feel meaningful
4. **Clear feedback loops** — Win/lose conditions make success measurable

---

## Coming Soon

Ideas for future games:

- **Reverse Turing** — The AI tries to convince you it's a specific famous person
- **Genre Roulette** — Spin the wheel, get a genre mashup, write a pitch
- **The Bureaucracy** — Navigate an absurdist approval process with infinite forms
- **Design Telephone** — Pass a visual concept through multiple AI interpretations

---

## Contributing

Have a game concept? PRs welcome. Good games should:

- Have clear rules that fit in a single prompt file
- Produce outputs that are genuinely different from naive prompting
- Be fun (this is surprisingly important)
- Work across different AI providers (though Claude is the primary target)
