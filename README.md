# Petal

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`



## Running docker project.
I have provided sample environment data inside `.env.sh` so, the first thing you need to do is load it to the terminal with this command. `source .env.sh`

Then run docker compose with `docker-compose up`

## Running release project
If you prefer the release file, run `mix release` then load the environment variable to the terminal using `source .env.sh`. After that run the generated release using `_build/dev/rel/petal/bin/petal start`

# Testing project
In order to test the project run, `mix test`


## NOTE: Am open for improvements if any are required.
