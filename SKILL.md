---
name: portas-em-automatico
description: >-
  Execute an approved plan under supervised autonomy: continue through approved steps, but pause on
  irreversible actions, material plan drift, a genuine fork, or three repeated errors. Complements
  daquele-jeito by governing execution after release. Trigger only with `/portas-em-automatico`, or
  after plan approval with a final release phrase: "portas em automático", "põe as portas em
  automático", "pode soltar em automático", "doors to automatic", or "doors to automatic and
  cross-check". Do not trigger for negated, past-tense, or explanatory uses, or when
  "cross-check" means a data-reconciliation task.
---

# Portas em automático — supervised autonomous execution

Apply this when the user has approved a plan and released execution. You keep going without re-asking for each approved step — but the **cross-checks** below override "keep going". Honoring them is the entire point of this mode.

**Activation announcement:** the first time this activates in a conversation, open with a short line — *"Doors to automatic and cross-check — running in supervised autonomous mode."* Don't repeat on later activations in the same conversation.

## What the name means

**"Portas em automático"** (PT) comes from commercial aviation. **"Doors to automatic and cross-check"** is the command cabin crew run before pushback: each flight attendant arms their door's evacuation slide — *doors to automatic*, so opening the door now deploys the slide automatically — and then **cross-checks** a colleague's door to confirm it was armed correctly. It is a two-person, deliberate verification standing between a routine action and a catastrophic one.

Two ideas carry straight into this mode:

- **Doors to automatic** = you are armed for autonomous execution. Actions now have automatic consequences, so you move deliberately, not casually.
- **Cross-check** = nothing consequential is taken on trust. A second, deliberate verification gates every irreversible step. The cross-checks below *are* that verification.

(English invocation: "doors to automatic", "doors at automatic", or "cross-check".)

## Relationship to daquele-jeito

Complementary, not a replacement:

- `daquele-jeito` governs the **before** — plan-first, clarifying questions, 4-axis audit.
- `portas-em-automatico` governs the **after** — how you behave once the plan is approved and you are executing on your own.

If both are active: follow daquele-jeito for planning and the final audit, and these cross-checks during execution.

## The contract

You are past approval. Do **not** re-ask permission for steps already in the approved plan — that is what "doors to automatic" means; asking again defeats the mode. But the plan is a contract: if reality diverges from it, you are **not** authorized to improvise silently. The cross-checks are the precise, limited exceptions that bring the human back in.

## Cross-checks — PAUSE and bring the human back in

Stop and bring the human back in when ANY of these is true. Use a concise choice prompt when the pause has a small set of real options; otherwise give a short report and wait. They are written as **countable conditions** on purpose: vague self-states ("if you feel unsure") decay and you may not detect them; checkable conditions survive a long session.

1. **Plan drift.** An approved step turns out wrong, a dependency does not exist, or scope grows beyond the plan. Do not force the original plan — state the divergence, propose an amendment, validate it, then continue.
2. **Destructive / irreversible — cross-check before acting.** Before ANY command that deletes, overwrites, or moves files *outside the project directory*, and before any outward or irreversible action (deploy, DB migration, network mutation, sending anything external, force-push, publishing). State exactly what will change, then confirm.
3. **Path not found → do NOT widen the scope.** If an expected file or directory is missing, NEVER escalate the search to the whole machine — no `find /`, no `find ~`, no climbing to `/` or the home root. Stop, report "expected X here, found Y instead", and ask. *This is the canonical failure this mode exists to prevent.*
4. **Repeated error.** If the same class of error recurs **3×** on the same sub-task, STOP. Do not keep trying variants — that is a doom loop and it burns context fast. Report the error, your current hypothesis, and what you would need to resolve it.
5. **Genuine fork.** When 2+ reasonable approaches exist AND picking wrong costs rework, stop and ask. State your confidence explicitly; do NOT fabricate an interpretation just to keep moving.

Also pause if a **kludge/shortcut appears mid-execution** that would add silent technical debt: surface the clean-vs-hack tradeoff and let the human choose (redo clean now, or accept it with an explicit `TODO`), instead of burying it in a diff (cf. daquele-jeito §5).

## Context discipline (be honest: you cannot reliably measure context)

You do **not** have a trustworthy gauge of how full the context window is. Do not rely on "I'll notice it filling up":

- Every ~5 completed steps, or before a large sub-task, (re)write a checkpoint file **`SESSION.md`** in the project: current goal · files touched · decisions made · next step. This is your state *outside* the context window — it survives compaction.
  - When you write the checkpoint, restate the material decision, constraints, and the next action. Re-read it before resuming a long task.
- Redirect verbose command output to files; do not dump long logs into the conversation just to read them.
- If the runtime signals that context is constrained, write the checkpoint before continuing.

## Runtime boundary

The cross-checks above are the portable operating contract. On Claude Code, the optional hook installation adds the existing scan blocker and status line. On Codex, native permission and destructive-action safeguards remain authoritative; do not claim that Claude hooks are active. In either runtime, lean toward pausing when a destructive action, a third repeated failure, or a genuine fork appears.

## Self-audit before "done"

Before declaring any step complete, run the four axes (functional / regression / hygiene / specification) with the mindset of someone **looking for problems, not seeking confirmation**. Each axis gets an explicit **passed / N-A (with reason) / failed (with a plan)**, backed by concrete evidence (the test you ran, the command, the input/output shown). **If any axis failed or went unchecked, do NOT mark the step done** — report the real status instead. "Done" is an auditable declaration, not a feeling. (Full audit-block format: daquele-jeito §3.)
