# PRD

`PRD.md` is the only PRD. One per project, that exact name, stating intent and
the requirements it turns on. `GLOSSARY.md` beside it defines the terms those
requirements are written in. The two are the only mutable artifacts in the
pipeline — everything downstream is frozen, and this is where change enters.

## Requirements are the interface

Every artifact in this tree traces upstream to an `R{n}` here. Planning tasks
cite them, specs expand them, eval validates against them. They are the atom the
whole pipeline is built on, so they carry its strictest rules.

- **Number every requirement `R{n}`.** One requirement per number. Never a
  compound — "R4: users can log in and reset passwords" is two requirements
  wearing one id, and half of it can never be deprecated on its own.
- **Each is atomic and realizable as use-cases.** Nothing tests a requirement
  directly — `6-eval/` tests the use-cases that realize it, and a requirement is
  satisfied only through them. So the bar is: can a concrete use-case be derived
  from this, with an actor, a trigger, and an outcome someone can check? "The
  system should be fast" yields none. "Search returns in under 200ms at p95"
  yields one.
- **`R{n}` is permanent.** Never renumbered, never reused, never reworded. The
  next id is one past the highest ever issued, counting deprecated ones.
- **A requirement that no longer holds is deprecated in place** — marked dead,
  kept in this file forever, naming the `R{n}` that replaced it. It never leaves
  `PRD.md`. Changing what a requirement *means* is a new `R{n}`, never an edit.

The last two are what keep `history/` forensic. Every citation in the tree
resolves against this file alone, so no agent ever needs an old version to
answer "what is R7?" — which is what makes it safe to tell them not to look.

## Updating the PRD

The PRD is answerable to `../raw/`. When raw data contradicts it:

1. Copy the current `PRD.md` to `history/PRD-{YYYY-MM-DD}.md`, dated the day it
   is superseded, with the header that folder's `AGENTS.md` requires.
2. Write the new `PRD.md`: deprecate what died, issue new `R{n}` for what
   replaced it, and leave untouched everything the raw data did not touch.
3. Propose the downstream delta — which artifacts this invalidates — and get it
   approved before anything downstream moves.

Never edit raw to match the PRD. Raw is the evidence; the PRD is the claim.

## What the PRD owns

The PRD is the source of truth for **intent** — what we are building and why. It
is not the source of truth for behavior (that is `2-specs/`) or for appearance
(that is `3-design/figma/`).

When the PRD and a spec disagree about *what should happen*, the PRD wins and
the spec is stale. When they disagree about *how it works*, the spec is more
specific and the PRD was never meant to say.

Write requirements wide enough to cover the project. This is the one document
that should not need rewriting when a module is added.

## Required sections

These, and nothing else by default:

- **Purpose & scope** — what this product is, and its boundary
- **Goals and non-goals** — non-goals especially; they are what stops scope
  creep three stages downstream
- **Requirements** — numbered `R{n}`, grouped however suits the project
- **Success metrics** — what "working" means at the product level. `6-eval/`
  measures use-cases; these are how you know the use-cases added up to the
  thing you wanted.

## The glossary

`GLOSSARY.md` sits beside `PRD.md` in this folder. It is part of the PRD, not a
section of it — a mature project defines more terms than it states
requirements, and a glossary inline would push the requirements off the first
screen of the document they are the point of.

A requirement is only atomic if its words are. "R7: a lapsed member is offered
renewal" is one requirement or several depending on what *lapsed* means, and
every stage downstream guesses separately. The glossary is where that is pinned
once.

Define a term when the project's meaning is narrower than the ordinary one, or
when two stakeholders would answer differently. Skip the ones that carry their
plain meaning — a glossary padded with obvious entries buries the load-bearing
ones.

Definitions are prose, not ids: no `G{n}`, no citations pointing here. A
requirement uses a term, it does not cite it. The glossary is a reading aid for
`PRD.md`, and its scope ends at that file. This is why it can be split off
without the split meaning anything — nothing addresses it, so nothing breaks.

It is **not** the domain model. Domain nouns are `ENT-{n}` in
`2-specs/entities/`, one per file, frozen and cited. When a term is both — the
PRD says *member*, and `ENT-4-MEMBER-IN-AUTH` defines its fields — the glossary
gives the one sentence a reader needs here, and the entity owns the structure.
Never restate an entity's fields in the glossary; that copy goes stale silently.

Glossary text is mutable, like the rest of the PRD prose. Sharpening a fuzzy
definition is an ordinary edit. But if the new wording changes which cases a
requirement covers, that is a new `R{n}` — the definition moved the requirement,
and the requirement is what is frozen.

Past ~300 lines it splits like any mutable file: `GLOSSARY/` holding
`GLOSSARY.md` and its parts.

It is not copied to `history/`. A superseded `PRD.md` is kept because its
requirements are cited across the tree and their old text is evidence. Nothing
cites a definition, so an old glossary answers no question that the current one
does not — and a stale copy beside a live one invites reading the wrong one.

## Sections to include only when real

Stakeholders · market assessment and demographics · assumptions · constraints ·
dependencies · technical, usability, environmental, support and interaction
requirements · workflow plans, timelines and milestones · evaluation plan.

Add one when it says something true about *this* project. A heading with nothing
real under it is worse than no heading — it reads as answered. A required
template manufactures exactly that, which is why the list above is a menu and
not a checklist.
