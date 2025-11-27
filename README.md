# prompts-and-stuff

**Prompts, games, skills, and scripts to do weird stuff with LLMs**

---

<p align="center">
  <em>"Because the default output is boring and we both know it."</em>
</p>

---

## What Is This?

A collection of experimental prompts, instruction sets, games, and creative tools designed to push language models beyond their factory settings. 

This is not "prompt engineering" in the LinkedIn-influencer sense. It is more like prompt tinkering. Prompt alchemy. Prompt "I wonder what happens if I tell it to write a children's book with nihilistic-awe settings."

Some things here are useful. Some are just fun. Most are accidents that turned out interesting. All of them make LLMs do things they would not do if you just asked nicely.

---

## Contents

### Pyro-Style Writing System

**Location:** [`prompts/pyro-style/`](./prompts/pyro-style/)

A 5-dimensional creative writing control system. Think of it as a mixing board for prose.

| Dimension | Controls | Range |
|-----------|----------|-------|
| **A** | Cadence / Rhythm | Ultra-staccato → Stream-of-consciousness |
| **B** | Emotional Exposure | Fully buried → Operatic grief |
| **C** | Surrealism / Liminality | Stark realism → Foggy, collapsed logic |
| **D** | Existential Pressure | Stillness → Nihilistic awe |
| **E** | Seriousness / Tone | Absurdist comedy → Funereal weight |

**Example codes:**

| Author | Code | Why |
|--------|------|-----|
| Cormac McCarthy | `12089` | Sparse, brutal, cosmically indifferent |
| Douglas Adams | `43210` | Conversational, absurdist, melancholy beneath jokes |
| Kafka | `21478` | Clean dread, uncanny bureaucracy, reality destabilized |
| Borges | `41787` | Precise yet dreamy, full surrealism, grave sincerity |
| Beckett | `10699` | Minimal, buried emotion, nihilistic awe, funereal |

**Files:**
- `prompt.md` — Original system prompt (v1)
- `prompt-v2.md` — Refined version with expanded author codes
- `example1.md`, `example2.md` — Sample outputs demonstrating the system
- `pyro-style1.png` — Visual reference

**Key feature:** The system enforces strict code adherence. No softening. No "more appropriate" suggestions. If you ask for a corporate memo at `99999` (stream-of-consciousness operatic grief about quarterly projections), that is what you get. The friction between style and subject is the point.

---

### Essence — The Design Guessing Game

**Location:** [`games/essence/`](./games/essence/)

A game where Claude transforms famous personalities into absurdist design artifacts (websites, posters, generative art) and the player guesses who it is.

**The concept:** "What if Gandhi WAS a website?" Not what Gandhi would design. What he IS, rendered as visual form. Politicians become landing pages. Philosophers become error states. Chefs become form validation.

**Game rules:**
- 10 rounds, progressively harder
- 3 guesses and 3 hints per round (reset each round)
- Difficulty scales on abstraction: Round 1 Trump has gold everywhere and actual quotes. Round 10 Trump is just aggressive gradients fighting for dominance.

**Output formats** (depending on available skills):
- Websites (HTML) — interactive, scrollable
- Posters (Canvas/PDF) — bold, gallery-worthy
- Algorithmic Art (p5.js) — generative, mathematical
- Animated GIFs — looping, chaotic
- Presentations (PPTX) — corporate absurdism
- Documents (DOCX) — bureaucratic horror

**Customization options:**
- People pool (politicians only, scientists, historical figures, etc.)
- Design constraints (brutalist, maximalist, specific palettes)
- Spice level (wholesome to controversial)

**To play:** Paste the prompt into Claude and say "Let's play Essence."

---

## Philosophy

**1. LLMs are weirder than their defaults suggest.**  
Most outputs feel samey because most prompts are samey. Structured constraints produce genuinely different results. The model can write like Beckett. You just have to ask correctly.

**2. Weird combinations are features, not bugs.**  
A children's story at nihilistic-awe settings. A recipe in stream-of-consciousness. A CEO rendered as a brutalist 404 page. The tension is generative. Sometimes you get nonsense. Sometimes you get art. Often both.

**3. Explicit beats implicit.**  
Vague instructions produce vague outputs. If you want something specific, build a system that makes it specifiable. "Write something sad" is worse than "B=7, E=8" (sensitive and raw, tragic weight).

**4. Games are underrated interfaces.**  
Structured play produces better outputs than open-ended requests. Constraints breed creativity. Rules create surprise.

---

## Usage

Each prompt or game is self-contained. Copy the relevant file into your LLM conversation (as a system prompt, custom instruction, or context attachment) and follow the instructions within.

```
1. Open your LLM of choice
2. Paste the prompt file contents
3. Start making requests
4. Watch it actually follow your weird instructions
```

Most are designed to work with any capable model (Claude, GPT-4, Gemini, etc.) but may behave differently across providers. That is part of the experiment.

**For Claude specifically:** Some prompts reference Claude's computer use capabilities (file creation, skills). These features work in Claude.ai with the appropriate settings enabled.

---

## Repository Structure

```
prompts-and-stuff/
├── games/
│   └── essence/
│       └── prompt.md          # The Design Guessing Game
├── prompts/
│   └── pyro-style/
│       ├── prompt.md          # Pyro-Style v1
│       ├── prompt-v2.md       # Pyro-Style v2 (refined)
│       ├── example1.md        # Sample output
│       ├── example2.md        # Sample output
│       └── pyro-style1.png    # Visual reference
├── LICENSE
└── README.md
```

---

## Contributing

Found something that makes LLMs do interesting things? PRs welcome. 

**The bar:**
- Does it produce genuinely different outputs than naive prompting?
- Is it documented enough that someone else can use it?
- Is it at least a little bit fun?

**Bonus points:**
- Breaking the system in creative ways
- Edge cases that produce unexpectedly good results
- New author codes for Pyro-Style
- New game concepts

---

## License

MIT. Do whatever you want with these. Attribution appreciated but not required.

---

<p align="center">
  <em>Capture their soul. Render it in CSS. Make them guess.</em>
</p>