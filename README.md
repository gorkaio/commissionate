# Commissionate

## Datastores

Events are stored in `commisionate_eventstore_{mix.env}` database, while projections use `commissionate_readstore_{mix.env}` database.

## Mix tasks

| Task             | Description                             |
|------------------|-----------------------------------------|
| `mix db.setup`   | Setup eventstore and read models        |
| `mix db.drop`    | Drop eventstore and read models         |
| `mix test.watch` | Run tests on code changes (TDD helper)  |
