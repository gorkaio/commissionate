# Commissionate

## API

### Merchants

Merchants are ecommerce shops we manage payments for. For each sale, we will retain a small fee.

#### List existing merchants

| HTTP Verb | URL            |
|-----------|----------------|
| GET       | /api/merchants |

Example response:
```
{
  "data": [
    {
      "name": "Acme",
      "id": "240462fe-2dbf-4a71-b135-43a85a0709c3",
      "email": "acme@example.com",
      "cif": "A1111111B"
    },
    {
      "name": "Acme",
      "id": "a1e4975b-7274-4d3b-9132-ec08531e2135",
      "email": "acme@example.com",
      "cif": "A1111112B"
    },
    {
      "name": "Hello",
      "id": "eb1f6eb1-b8cb-40b0-9346-1ae8b0583f95",
      "email": "hello@example.com",
      "cif": "B1112223C"
    }
  ]
}
```

#### Show merchant data

| HTTP Verb | URL                 | Parameters |
|-----------|---------------------|------------|
| GET       | /api/merchants/:cif | cif        |

Example response:
```
{
  "data": {
    "name": "Acme",
    "id": "a1e4975b-7274-4d3b-9132-ec08531e2135",
    "email": "acme@example.com",
    "cif": "A1111112B"
  }
}
```

#### Register new merchant

| HTTP Verb | URL            | Required fields  |
|-----------|----------------|------------------|
| POST      | /api/merchants | name, email, cif |

Example request:

```
{
  "merchant":{
    "name": "Acme",
    "email": "acme@example.com",
    "cif": "A1111111B"
  }
}
```

Example response:
```
{
  "data": {
    "id": "5ff3aec7-9f67-4126-8135-110802d7b614",
    "name": "Acme",
    "email": "acme@example.com",
    "cif": "A1111111B"
  }
}
```

Should any field validation fail, the response will be show an HTTP status code `422` with body like:
```
{
  "errors": {
    "cif": [
      "can't be empty"
    ]
  }
}
```

### Shoppers

Shoppers are ecommerce customers who choose to use our payment service to purchase goods from a merchants. For each sale, we will retain a small fee.

#### List existing shoppers

| HTTP Verb | URL           |
|-----------|---------------|
| GET       | /api/shoppers |

Example response:
```
{
  "data": [
    {
      "name": "Alice",
      "id": "240462fe-2dbf-4a71-b135-43a85a0709c3",
      "email": "alice@example.com",
      "nif": "11111111B"
    },
    {
      "name": "Bob",
      "id": "a1e4975b-7274-4d3b-9132-ec08531e2135",
      "email": "bob@example.com",
      "nif": "22222222C"
    },
    {
      "name": "John",
      "id": "eb1f6eb1-b8cb-40b0-9346-1ae8b0583f95",
      "email": "john@example.com",
      "nif": "33333333J"
    }
  ]
}
```

#### Show shopper data

| HTTP Verb | URL                | Parameters |
|-----------|--------------------|------------|
| GET       | /api/shoppers/:nif | nif        |

Example response:
```
{
  "data": {
    "name": "Alice",
    "id": "a1e4975b-7274-4d3b-9132-ec08531e2135",
    "email": "alice@example.com",
    "cif": "11111112B"
  }
}
```

#### Register new shopper

| HTTP Verb | URL           | Required fields  |
|-----------|---------------|------------------|
| POST      | /api/shoppers | name, email, nif |

Example request:

```
{
  "shopper":{
    "name": "Alice",
    "email": "alice@example.com",
    "nif": "11111111B"
  }
}
```

Example response:
```
{
  "data": {
    "id": "5ff3aec7-9f67-4126-8135-110802d7b614",
    "name": "Alice",
    "email": "alice@example.com",
    "nif": "a1111111B"
  }
}
```

Should any field validation fail, the response will be show an HTTP status code `422` with body like:
```
{
  "errors": {
    "nif": [
      "can't be empty"
    ]
  }
}
```

## Datastores

Events are stored in `commisionate_eventstore_{mix.env}` database, while projections use `commissionate_readstore_{mix.env}` database.

## Mix tasks

| Task             | Description                             |
|------------------|-----------------------------------------|
| `mix db.setup`   | Setup eventstore and read models        |
| `mix db.drop`    | Drop eventstore and read models         |
| `mix test.watch` | Run tests on code changes (TDD helper)  |
