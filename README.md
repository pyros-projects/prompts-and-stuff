# prompts-and-stuff

**Prompts, skills, scripts to do weird stuff with LLMs**

---

<p align="center">
  <em>"Because the default output is boring and we both know it."</em>
</p>

---

## 🤷 What Is This?

A collection of experimental prompts, instruction sets, and creative tools designed to push language models beyond their factory settings. 

This isn't "prompt engineering" in the LinkedIn-influencer sense. It's more like... prompt tinkering? Prompt alchemy? Prompt "I wonder what happens if I tell it to write a children's book with nihilistic-awe settings"?

Some things here are useful. Some are just fun. Most are accidents that turned out interesting. All of them make LLMs do things they wouldn't do if you just asked nicely.

---

## 📦 Contents

### 🔥 Pyro-Style Writing System
**File:** [`./prompts/pyro-style.md`](./prompts/pyro-style/pyro-style.md)

A 5-dimensional creative writing control system. Think of it as a mixing board for prose:

| Dimension | Range |
|-----------|-------|
| **A – Cadence** | Ultra-staccato → Stream-of-consciousness |
| **B – Emotional Exposure** | Fully buried → Operatic grief |
| **C – Surrealism** | Stark realism → Foggy, collapsed logic |
| **D – Existential Pressure** | Stillness → Nihilistic awe |
| **E – Seriousness** | Absurdist comedy → Funereal weight |

**What's Cormac McCarthy's number?** `12089` — sparse, brutal, cosmically indifferent.  
**Douglas Adams?** `43210` — conversational, absurdist, melancholy hiding beneath the jokes.  
**Kafka?** `21478` — clean dread, uncanny bureaucracy, reality destabilized.

The system includes:
- Author reference codes for 14+ writers
- Dynamic style generation when no code is specified (proposes 3 options, asks you to pick)
- **Strict enforcement**: LLMs *must* honor the code. No softening. No "more appropriate" suggestions. The friction between style and subject is the point.

Want a corporate memo written at `99999`? Stream-of-consciousness operatic grief about quarterly projections? Go for it. That's the whole idea.

---

## 🧠 Philosophy

**1. LLMs are weirder than their defaults suggest.**  
Most outputs feel samey because most prompts are samey. Structured constraints produce genuinely different results. The model *can* write like Beckett. You just have to ask correctly.

**2. Weird combinations are features, not bugs.**  
A children's story at nihilistic-awe settings. A recipe written in stream-of-consciousness. The tension is generative. Sometimes you get nonsense. Sometimes you get art. Often both.

**3. Explicit > implicit.**  
Vague instructions produce vague outputs. If you want something specific, build a system that makes it specifiable. "Write something sad" is worse than "B=7, E=8" (sensitive and raw, tragic weight).

---

## 🚀 Usage

Each prompt/system is self-contained. Copy the relevant file into your LLM conversation (as a system prompt, custom instruction, or context attachment) and follow the instructions within.

```
1. Open your LLM of choice
2. Paste the prompt file contents
3. Start making requests
4. Watch it actually follow your weird instructions
```

Most are designed to work with any capable model (Claude, GPT-4, Gemini, etc.) but may behave differently across providers. That's part of the experiment. If Claude does something interesting that GPT refuses, that's data.

---

## 🤝 Contributing

Found something that makes LLMs do interesting things? PRs welcome. 

**The bar:**
- Does it produce genuinely different outputs than naive prompting?
- Is it documented enough that someone else can use it?
- Is it at least a little bit fun?

**Bonus points:**
- Breaking the system in creative ways
- Edge cases that produce unexpectedly good results
- Author codes we haven't mapped yet

---

## 📜 License

MIT. Do whatever you want with these. Attribution appreciated but not required.

