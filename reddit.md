# I built a 5-digit "mixing board" for creative writing styles 

The wife and coworkers are loving it, and I thought you guys would like it as well

**TL;DR:** A 5-digit code controls prose style across 5 dimensions. `12089` = Cormac McCarthy. `43210` = Douglas Adams. Works surprisingly well.

---

I've been experimenting with a system I call "Pyro-Style" — basically a mixing board for prose. Each digit (0-9) controls a different stylistic dimension:

| Digit | Dimension | 0 → 9 |
|-------|-----------|-------|
| **A** | Cadence | Ultra-staccato → Stream-of-consciousness |
| **B** | Emotional Exposure | Fully buried → Operatic grief |
| **C** | Surrealism | Stark realism → Foggy, collapsed logic |
| **D** | Existential Pressure | Stillness → Nihilistic awe |
| **E** | Seriousness | Absurdist comedy → Funereal weight |

Just prompt: *"Write a story in Pyro-Style 47203"* and Claude builds a consistent voice from the dimensional values.

---

## Why bother?

**1. Consistency.** Found a style you love? Just remember the number. No more "write it like that thing you did three chats ago."

**2. Deliberate friction.** The magic happens when style and subject *clash*. Cosmic horror written like an IKEA manual? Children's bedtime story in Beckett-esque nihilism (`10699`)? Corporate memo as operatic grief (`99999`)? That's where it gets interesting.

**3. Exploration.** You can dial in combinations that don't map to any existing author. What does `55555` even feel like? Now you can find out.

---

## Author Cheat Sheet

| Author | Code | Vibe |
|--------|------|------|
| **Hemingway** | `10004` | Staccato, buried, stark, still, neutral |
| **Cormac McCarthy** | `12089` | Sparse, brutal, cosmically indifferent |
| **Douglas Adams** | `43210` | Conversational absurdism, melancholy beneath the jokes |
| **Kafka** | `21478` | Clean dread, uncanny bureaucracy |
| **Murakami** | `63635` | Flowing, liminal, looping regret |
| **García Márquez** | `76659` | Dreamy, emotionally open, magical grief |
| **Virginia Woolf** | `87869` | Poetic drift, identity unraveling |
| **Pratchett** | `53311` | Lyrical wit, gently absurd |

(Full prompt has 14+ authors mapped to ground these styles somehow...)

---

## Beyond Fiction

This "dimensional prompt space" pattern works for other domains too:

- **Code review tone:** Dimension A = bluntness, B = encouragement, C = detail level, D = formality, E = emoji usage. `"Review this PR in style 73802"`
- **Email drafting:** A = length, B = warmth, C = urgency, D = formality, E = directness
- **Explanations:** A = technical depth, B = analogy usage, C = humor, D = assumed expertise, E = verbosity
- **Recipe writing:** A = precision, B = storytelling, C = technique focus, D = ingredient flexibility, E = pretentiousness level

The core idea: **define dimensions, assign 0-9 scales, let a single code configure the whole output.** It's oddly satisfying once you internalize it and imho crazy under utilized/rated. At least it's a prompt-pattern I rarely see, and I've seen plenty.

---

## Try It

https://raw.githubusercontent.com/pyros-projects/prompts-and-stuff/refs/heads/main/prompts/pyro-style.md

Drop this in your system prompt or Claude Project instructions. Then ask for a story about anything with a random 5-digit code. See what happens.

Some fun combos to start:
- `00000` — the most minimal, emotionless, realistic, still, absurd thing possible
- `99999` — maximum everything: stream-of-consciousness operatic surrealist nihilistic elegy
- `50505` — perfectly balanced (as all things should be)
- `12345` — a neat gradient across all dimensions

If you ask Claude to write fiction without specifying a style, it will recommend a sensible option along with some wild ones.

Of course, feel free to replace "Pyro-Style" with whatever name floats your boat.

Cheers,
Pyro

