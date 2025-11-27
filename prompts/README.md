# ✍️ Prompts

**Creative writing systems and experimental instruction sets**

This folder contains prompt systems that fundamentally change how LLMs approach creative tasks. Not simple "write me a story" prompts—these are structured systems with dimensions, codes, and explicit controls.

---

## Available Systems

### [Pyro-Style Writing System](./pyro-style/)

A 5-dimensional creative writing control system. Think of it as a mixing board for prose.

| Dimension | Controls | Range |
|-----------|----------|-------|
| **A** | Cadence / Rhythm | Ultra-staccato → Stream-of-consciousness |
| **B** | Emotional Exposure | Fully buried → Operatic grief |
| **C** | Surrealism / Liminality | Stark realism → Foggy, collapsed logic |
| **D** | Existential Pressure | Stillness → Nihilistic awe |
| **E** | Seriousness / Tone | Absurdist comedy → Funereal weight |

**How it works:** Specify a 5-digit code like `12089` and the AI writes in that exact style. No softening. No "more appropriate" suggestions. The code is law.

**Example codes by author:**

| Author | Code | Why |
|--------|------|-----|
| Cormac McCarthy | `12089` | Sparse, brutal, cosmically indifferent |
| Douglas Adams | `43210` | Conversational, absurdist, melancholy beneath jokes |
| Kafka | `21478` | Clean dread, uncanny bureaucracy, reality destabilized |
| Borges | `41787` | Precise yet dreamy, full surrealism, grave sincerity |
| Beckett | `10699` | Minimal, buried emotion, nihilistic awe, funereal |

**The power move:** Ask for combinations that seem wrong. A children's bedtime story at `10699`. A corporate memo at `99999`. The friction between style and subject is generative.

---

## Folder Contents

```
prompts/
├── README.md                    # This file
└── pyro-style/
    ├── prompt.md                # Original system prompt (v1)
    ├── prompt-v2.md             # Extended version with 11 dimensions
    ├── example1.md              # Sample output: Borges-style cosmic horror
    ├── example2.md              # Sample output: Ultra-staccato eldritch mystery
    └── pyro-style1.png          # Visual reference
```

---

## Pyro-Style Versions

### v1 (`prompt.md`)
The original 5-dimension system. Clean, intuitive, covers most creative writing needs. Use this if you want simplicity.

### v2 (`prompt-v2.md`)
Extended to 11 dimensions with modular format support:

| Dimension | Controls |
|-----------|----------|
| F | Sensory Density |
| G | Syntactic Complexity |
| H | Narrative Distance |
| I | Metaphoric Density |
| J | Temporal Velocity |
| K | Vocabulary Register |

**Modular format:** `Pyro-Style ABFJK = 00009` — Only specify the dimensions you care about. Unspecified dimensions float at the author's discretion.

---

## Example Outputs

### Example 1: Borges-style (`41787`)
*"The Enumerator"* — A short story about an archivist who discovers a book cataloguing everything that exists, complete with significance ratings and deletion schedules. Precise, dreamy, grave sincerity.

### Example 2: Ultra-staccato eldritch (`00009`)
*"The Cartographer's Record"* — A researcher discovers islands that appear on old maps but don't exist on modern charts. Minimal sentences. Maximum dread. The facts are horrifying enough.

---

## How to Use

1. **Copy the prompt file** (`prompt.md` or `prompt-v2.md`) into your LLM conversation
2. **Request creative writing** with or without a code:
   - With code: *"Write a story about a lighthouse keeper. Use Pyro-Style 63635."*
   - Without code: The AI will propose three style options and ask you to choose
3. **Experiment with mismatches** — The weird combinations are where interesting things happen

---

## Why This Works

Traditional prompts like "write something sad" are interpreted by the AI. It decides what "sad" means. The output converges toward generic.

Pyro-Style codes are *specifications*. Each digit controls a specific aspect of the prose. The AI has less room to interpret, which paradoxically produces more distinctive results.

**The key insight:** Explicit beats implicit. If you can name the dimension, you can control it.

