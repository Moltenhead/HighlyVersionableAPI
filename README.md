# README

## Usage

### Docker Haters

If you don't use docker, simply remove `host: database` within `config/database.yml` and setup an environnement with rails 6.1.4 and last version of PostgreSQL
Then start the app with `rails s`, or the specs with `rspec spec/`

### Docker Users

First you need to call `make up-build` within the app root folder to start docker containers.
If it happens to request for a migration update - it shouldn't - call `make backend-migrate`.

Then you can do these :

* call `make backend-spec` to run all specs
* call `make backend` to access the backend container through cmd

## Exploring the API

You can explore the API at `localhost:3000` :

method | uri | action
-------|-----|-------
`GET`|`/api/v1/ibans`|index
`GET`|`/api/v1/ibans/random_pick`|get a random record
`POST`|`/api/v1/ibans`|create
`GET`|`/api/v1/ibans/:id`|show
`GET`|`/api/v1/ibans/:name`|show
`PATCH`|`/api/v1/ibans/:id`|update
`PATCH`|`/api/v1/ibans/:name`|update
`DESTROY`|`/api/v1/ibans/:id`|destroy
`DESTROY`|`/api/v1/ibans/:name`|destroy

expected body for parameter is kept simple :
```json
{
  "name": "FR1420041010050500013M02606",
  "region": "FRANCE"
}
```

It will throw an error if you try to add or mutate a record with an invalid frensh IBAN.
It also handles UK IBANS, try :
```json
{
  "name": "GB26MIDL40051512345678",
  "region": "UK"
}
```

blank spaces within the record `name` will be removed if passing it through the API.

## Ideology

I've made the code structure as RESTful as possible, exporting all the logci within the controller, for API high versionability.
Validations are stored within concerns to give the ability to reuse them in further versions.
Each CRUD action is segregated within its own concern to enforce action limitation on each controller.

Controllers composition structure :

_|_|_|_|_|_|_
-|-|-|-|-|-|-
Main::ApplicationController| | | | | |
Composition through concerns|=>|Api::ApplicationController| | | |
| | |Compositon through concerns|=>|Api::V{n}::ApplicationController| | |
| | | | |Composition through concern|=>|Model specific controller



Hope you will enjoy exploring the ideas I had fun developping.

See you soon.

Charlie Gardai
Freelance Software Developper
