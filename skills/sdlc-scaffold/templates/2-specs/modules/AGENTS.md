A module is the unit a planning task (PT-{number}) maps onto, and the name that
appears in the -IN-MODULE suffix of every actor, entity, event, and use-case id.

Each module should cover:
- links back to its source planning task(s)
- the actors, entities, and events it owns
- its boundary — what it explicitly does not own

Define the module first. Specs elsewhere in 2-specs/ cite it by name in their
ids, so a module invented after the fact leaves those ids pointing at nothing.
