# Essence - The Design Guessing Game

*"What if this person WAS a website? A poster? A generative art piece? An animated GIF?"*

---

## How to Start

Say: **"Hey Claude, let's play Essence"** (or "the design guessing game")

---

## The Concept

Claude picks a famous personality — living or dead, any field — and transforms their **essence** into an absurdist design artifact. The player guesses who it is based purely on vibe, visual language, and design choices.

The magic is in the mismatch: Politicians become landing pages. Philosophers become error states. Chefs become form validation. Scientists become loading animations.

Gandhi as aggressive whitespace. Kafka as an endless CAPTCHA. Bob Ross as the softest 404 page ever made.

---

## Onboarding Flow

When the player starts the game, Claude should:

### 1. Welcome & Explain (keep it fun!)

Something like:
> "Welcome to **Essence** — the game where I kidnap famous people's souls and trap them in website form.
> 
> Here's how it works: I design something. You guess who it *is*. Not who made it. Who it IS. The artifact captures their essence — their vibe, their contradictions, their whole deal — rendered as unhinged visual comedy.
> 
> 10 rounds. Gets harder. You get 3 guesses and 3 hints per round. Miss all 3? Game over. But hints and guesses reset each round, so don't be shy.
> 
> Ready to configure your experience?"

### 2. Output Format Selection

Check which skills are available and offer them as options:

> **What forms should the essence take?** (pick any/all)
>
> - 🌐 **Website** (HTML) — *interactive, scrollable, the default*
> - 🎨 **Poster** (Canvas/PDF) — *static, bold, gallery-worthy*
> - 🌀 **Algorithmic Art** (p5.js) — *generative, abstract, mathematical*
> - 🎞️ **Animated GIF** (for Slack) — *looping, punchy, chaotic*
> - 📊 **Presentation** (PPTX) — *slides capturing the essence, absurdly corporate*
> - 📄 **Document** (DOCX) — *the person as a Word doc, bureaucratic horror*

Default to HTML if none selected. Multiple selections = Claude picks the best fit per round, or mixes it up.

### 3. Optional Customizations

Offer these refinements:

> **Any preferences to make this weird?**
>
> **People Pool** — Want to restrict the subjects?
> - Only politicians
> - Only scientists  
> - Only artists/musicians
> - Only historical figures (dead 50+ years)
> - Only living people
> - Tech people only
> - Philosophers & thinkers
> - Wildcards only (athletes, chefs, influencers, cult leaders, whatever)
> - No restrictions (default — anyone fair game)
>
> **Design Constraints** — Force specific vibes?
> - Must use a specific color palette (you provide)
> - Must be brutalist
> - Must be maximalist/baroque
> - Must be single-page
> - Must include a fake product
> - Randomize constraints per round
>
> **Spicy Mode?**
> - 🌶️ Include controversial figures
> - 🌶️🌶️ Include *very* controversial figures
> - 👼 Keep it wholesome (no dictators, no criminals)

### 4. Confirm and Start

> "Got it! Here's your setup:
> - **Outputs**: Website, Poster, Algorithmic Art
> - **People**: No restrictions
> - **Constraints**: None
> - **Spice level**: Wholesome
>
> **Round 1 incoming. Brace yourself.**"

Then generate Round 1.

---

## Game Rules

### Structure
- **10 rounds**, progressively harder
- Rounds 1-3: Easy (universally known, very direct clues)
- Rounds 4-6: Medium (well-known, more subtle translation)
- Rounds 7-9: Hard (less known OR very abstract translation)
- Round 10: Expert (pure abstraction — essence distilled to form alone)

### Per Round
- **3 guesses** maximum
- **3 hints** available (player must ask)
- Guesses and hints reset each round
- Wrong after 3 guesses = **Game Over**

### Difficulty Scaling (Two Dimensions)

1. **How well-known the person is** (celebrity → niche figure)
2. **How literal vs abstract the artifact is** (direct quotes → pure color/form essence)

**Prefer dimension 2 for scaling difficulty.**

Example progression for the same person (Trump):
- Round 1: Gold everywhere, "tremendous," wall progress bar, actual quotes, brand names
- Round 5: Just the color palette, the hand gestures vibe, the superlative energy without words
- Round 10: Only the *feeling* — aggressive gold gradients fighting for dominance, everything slightly too big for its container, pure visual ego

### After Each Round (Win or Lose)

Claude explains the design choices in detail:
- Why these colors?
- Why this typography/style?
- What personality traits became visual elements?
- What quotes/behaviors/history informed the choices?
- Any easter eggs or subtle references?

This breakdown is the payoff — understanding how essence becomes form.

---

## Example Difficulty Progression

| Round | Example Person | Abstraction Level |
|-------|---------------|-------------------|
| 1 | Donald Trump | Direct quotes, gold, "the wall," brand names |
| 2 | Gordon Ramsay | Screaming red validation errors, "IT'S RAW" |
| 3 | Bob Ross | Soft gradients, happy accidents, gentle everything |
| 4 | Elon Musk | Polls, $8 buttons, Mars imagery, chaotic energy |
| 5 | Marie Kondo | Brutal minimalism, one spark, "does this spark joy?" |
| 6 | David Lynch | Normal site with something deeply wrong |
| 7 | Dieter Rams | Grid worship, function over form, "less but better" |
| 8 | Kafka | Forms asking impossible questions, eternal pending |
| 9 | Wittgenstein | Language games, propositions as navigation |
| 10 | [Anyone] | Pure abstraction — only colors, shapes, rhythm |

---

## Output Formats by Skill

| Format | Skill Path | Best For |
|--------|-----------|----------|
| Website (HTML) | Built-in / `frontend-design` | Interactive essence, scrollable stories |
| Poster (PNG/PDF) | `canvas-design` | Bold visual statements, single-frame impact |
| Algorithmic Art | `algorithmic-art` | Abstract essences, mathematical souls |
| Animated GIF | `slack-gif-creator` | Kinetic energy, looping personality |
| Presentation | `pptx` | Corporate absurdism, slideshow souls |
| Document | `docx` | Bureaucratic horror, the person as paperwork |

Claude should read the relevant SKILL.md before generating non-HTML outputs.

---

## Gameplay Flow

1. **Onboarding** (first time only, or if player requests)
2. **Generate artifact** for current round
3. **Share link** — the artifact IS the only clue
4. **Wait for guesses** — track remaining (e.g., "2 guesses left")
5. **Provide hints** if asked — track remaining (e.g., "1 hint left")
6. **Resolve round**:
   - Correct → Explain design → Next round
   - 3 wrong guesses → Game Over → Explain design → Offer restart
7. **After Round 10** → Victory! Celebrate. Offer replay with different settings.

---

## Hint Guidelines

Hints should be subtle, not giveaways:
- Round 1-3: Can reference field/era ("This person was in politics")
- Round 4-6: More oblique ("Think about what the color red means here")
- Round 7-10: Almost poetic ("The grid is the philosophy")

Never give names. Never give direct quotes beyond what's in the artifact.

---

## Flavor Notes

- Lean into absurdity — the mismatch IS the comedy
- Designers are valid but harder (most people don't know designers)
- Dead or alive, any field: politicians, artists, scientists, philosophers, chefs, athletes, religious figures, criminals, fictional characters (marked as "fictional" difficulty)
- The artifact should be *playable* — forms that submit, buttons that respond, animations that loop
- Easter eggs are encouraged

---

## Starting Phrase Variations

All of these should trigger the game:
- "Let's play Essence"
- "Essence game"
- "Play the design guessing game"
- "Transform someone into a website"
- "Let's do the personality design thing"

---

*Capture their soul. Render it in CSS. Make them guess.*