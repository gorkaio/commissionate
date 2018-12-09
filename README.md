# Commissionate

CQRS+ES application developed with Elixir

## Running the app

### Pre-requisites

You will need to have docker available and a working internet connection to retrieve the app dependencies.

### Run

```sh
docker-compose build
docker-compose up
```

This will build the containers, fetch dependencies and compile the app and finally start it on `http://localhost:4000`. It will take quite some time the first time while the app is being compiled, so please be patient.

See the API documentation below.

## API

### Merchants

Merchants are ecommerce shops we manage payments for. For each sale, we will retain a small fee.

#### Register new merchant

| HTTP Verb | URL            | Required fields  | Headers                        |
|-----------|----------------|------------------|--------------------------------|
| POST      | /api/merchants | name, email, cif | Content-Type: application/json |

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

| Headers                            |
|------------------------------------|
| location: /api/merchants/A1111111B |

```
{
  "data": {
      "name": "Acme",
      "id": "071967e1-f72f-4c44-8331-b1ce8a90959e",
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
          "already taken"
      ]
  }
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
      "id": "071967e1-f72f-4c44-8331-b1ce8a90959e",
      "email": "acme@example.com",
      "cif": "A1111111B"
  }
}
```

#### List existing merchants

| HTTP Verb | URL            | Optional query filters (ie: /api/merchants?name=Acme) |
|-----------|----------------|-------------------------------------------------------|
| GET       | /api/merchants | id, cif, email, name                                  |

Example response:
```
{
  "data": [
      {
          "name": "Acme",
          "id": "071967e1-f72f-4c44-8331-b1ce8a90959e",
          "email": "acme@example.com",
          "cif": "A1111111B"
      },
      {
          "name": "FooBar Inc",
          "id": "bd1e5053-0ed9-4c9d-8c8b-6c7b544706d1",
          "email": "foobar@example.com",
          "cif": "A1234567B"
      }
  ]
}
```

### Shoppers

Shoppers are ecommerce customers who choose to use our payment service to purchase goods from a merchants. For each sale, we will retain a small fee.

#### Register new shopper

| HTTP Verb | URL           | Required fields  | Headers                        |
|-----------|---------------|------------------|--------------------------------|
| POST      | /api/shoppers | name, email, nif | Content-Type: application/json |

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

| Headers                           |
|-----------------------------------|
| location: /api/shoppers/11111111B |

```
{
  "data": {
      "nif": "11111111B",
      "name": "Alice",
      "id": "86123fab-093a-404d-892e-5dea14aea586",
      "email": "alice@example.com"
  }
}
```

Should any field validation fail, the response will be show an HTTP status code `422` with body like:
```
{
  "errors": {
      "nif": [
          "already taken"
      ]
  }
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
        "nif": "11111111B",
        "name": "Alice",
        "id": "86123fab-093a-404d-892e-5dea14aea586",
        "email": "alice@example.com"
    }
}
```

#### List existing shoppers

| HTTP Verb | URL           | Optional query filters (ie: /api/shoppers?nif=11111111B) |
|-----------|---------------|----------------------------------------------------------|
| GET       | /api/shoppers | id, nif, email, name                                     |

Example response:
```
{
    "data": [
        {
            "nif": "11111111B",
            "name": "Alice",
            "id": "86123fab-093a-404d-892e-5dea14aea586",
            "email": "alice@example.com"
        },
        {
            "nif": "12345678C",
            "name": "Bob",
            "id": "606a4030-6109-4305-99c0-4aa0312369f9",
            "email": "bob@example.com"
        }
    ]
}
```

#### Register new order

Amounts are always in cents

| HTTP Verb | URL                | Required fields              | Headers                        |
|-----------|--------------------|------------------------------|--------------------------------|
| POST      | /api/shoppers/:nif | amount (cents), merchant_cif | Content-Type: application/json |

Example request:

```
{
  "order":{
    "merchant_cif": "A1234567B",
    "amount": 2345
  }
}
```

Example response:

| Headers                                                                       |
|-------------------------------------------------------------------------------|
| location: /api/shoppers/11111111B/orders/756106ed-ca38-4630-a3ad-f2fa778dd1e0 |

```
{
    "data": {
        "shopper_nif": "11111111B",
        "purchase_date": "2018-12-06T09:37:01.338119Z",
        "merchant_cif": "A1234567B",
        "id": "756106ed-ca38-4630-a3ad-f2fa778dd1e0",
        "confirmation_date": null,
        "amount": 2345,
        "status": "UNCONFIRMED"
    }
}
```

Should any field validation fail, the response will be show an HTTP status code `422` with body like:
```
{
    "errors": {
        "amount": [
            "invalid amount"
        ]
    }
}
```

#### Confirm an order

Registered orders can be confirmed through a PATCH operation on the status field or the order

| HTTP Verb | URL                                 | Required fields       | Headers                        |
|-----------|-------------------------------------|-----------------------|--------------------------------|
| PATCH     | /api/shoppers/:nif/orders/:order_id | nif, order_id, status | Content-Type: application/json |

Example request:

```
{
	"order": {
		"status": "CONFIRMED"
	}
}
```

Example response:

| Headers                                                                       |
|-------------------------------------------------------------------------------|
| location: /api/shoppers/11111111B/orders/756106ed-ca38-4630-a3ad-f2fa778dd1e0 |

```
{
    "data": {
        "shopper_nif": "11111111B",
        "purchase_date": "2018-12-06T09:37:01.338119Z",
        "merchant_cif": "A1234567B",
        "id": "756106ed-ca38-4630-a3ad-f2fa778dd1e0",
        "confirmation_date": null,
        "amount": 2345,
        "status": "CONFIRMED"
    }
}
```

Should any field validation fail, the response will be show an HTTP status code `422` with body like:
```
{
    "errors": {
        "status": [
            "invalid status"
        ]
    }
}
```

#### Show order data

| HTTP Verb | URL                                  | Required fields  |
|-----------|--------------------------------------|------------------|
| GET       | /api/shoppers/:nif/orders/:order_id  | nif, order_id    |

Example response:
```
{
    "data": {
        "shopper_nif": "11111111B",
        "purchase_date": "2018-12-06T09:37:01.338119Z",
        "merchant_cif": "A1234567B",
        "id": "756106ed-ca38-4630-a3ad-f2fa778dd1e0",
        "confirmation_date": null,
        "amount": 2345,
        "status": "UNCONFIRMED"
    }
}
```

#### List existing shopper orders

| HTTP Verb | URL                       | Required fields  |
|-----------|---------------------------|------------------|
| GET      | /api/shoppers/:nif/orders  | nif              |

Example response:
```
{
    "data": [
        {
            "shopper_nif": "11111111B",
            "purchase_date": "2018-12-06T09:37:01.338119Z",
            "merchant_cif": "A1234567B",
            "id": "756106ed-ca38-4630-a3ad-f2fa778dd1e0",
            "confirmation_date": null,
            "amount": 2345,
            "status": "UNCONFIRMED"
        },
        {
            "shopper_nif": "11111111B",
            "purchase_date": "2018-12-06T09:38:58.716741Z",
            "merchant_cif": "A1234567B",
            "id": "fe036db7-24b2-470a-90f9-952c6e59c42f",
            "confirmation_date": null,
            "amount": 9876,,
            "status": "UNCONFIRMED"
        }
    ]
}
```

### Orders

#### List orders

| HTTP Verb | URL         | Optional query filters (ie: /api/orders?shopper_nif=11111111B)                       |
|-----------|-------------|--------------------------------------------------------------------------------------|
| GET       | /api/orders | shopper_id, shopper_nif, merchant_id, merchant_cif, purchase_date, confirmation_date |                                                            |

Example response:
```
{
    "data": [
        {
            "shopper_nif": "11111111B",
            "purchase_date": "2018-12-06T09:37:01.338119Z",
            "merchant_cif": "A1234567B",
            "id": "756106ed-ca38-4630-a3ad-f2fa778dd1e0",
            "confirmation_date": null,
            "amount": 2345,
            "status": "UNCONFIRMED"
        },
        {
            "shopper_nif": "11111111B",
            "purchase_date": "2018-12-06T09:38:58.716741Z",
            "merchant_cif": "A1234567B",
            "id": "fe036db7-24b2-470a-90f9-952c6e59c42f",
            "confirmation_date": null,
            "amount": 9876,,
            "status": "UNCONFIRMED"
        }
    ]
}
```

### Disbursements

#### List disbursements

| HTTP Verb | URL                | Optional query filters (ie: /api/disbursements?merchant_cif=A1111111B) |
|-----------|--------------------|------------------------------------------------------------------------|
| GET       | /api/disbursements | merchant_id, merchant_cif, payment_date                                |

Example response:
```
{
    "data": [
        {
            "payment_date": "2018-12-10",
            "merchant_cif": "A1111111B",
            "amount": 19734
        }
    ]
}
```

## Datastores

Events are stored in `commisionate_eventstore_{mix.env}` database, while projections use `commissionate_readstore_{mix.env}` database.

## Mix tasks

| Task             | Description                             |
|------------------|-----------------------------------------|
| `mix db.setup`   | Setup eventstore and read models        |
| `mix db.drop`    | Drop eventstore and read models         |
| `mix phx.server` | Start application (localhost:4000)      |
| `mix test.watch` | Run tests on code changes (TDD helper)  |
