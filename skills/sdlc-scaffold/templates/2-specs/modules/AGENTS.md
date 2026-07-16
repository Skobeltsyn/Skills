A module is the unit a planning task (`PT-{number}`) maps onto, and the name
that appears in the `-IN-{MODULE}` suffix of every actor, entity, event, and
use-case id.

Each module states:
- the actors, entities, and events it owns
- its boundary — what it explicitly does not own

Define modules before any other spec. Specs cite the module by name inside their
own ids, so a module invented after the fact leaves those ids pointing at
nothing — and those ids are frozen.
