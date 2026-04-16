# README

This is a soccer prediction fantasy game written in Ruby on Rails.
It uses Hotwire for the frontend and the solid stack.

It is very much still in an alpha testing phase, but I hope to finish this in time before next season starts mid August.

It uses data from the great https://www.football-data.org/ api service which has a very nice free tier. You will need an api key if you want to test this locally.

For now it has the English Premier League, but everything is set up so that adding other leagues is quite simple.

To get this working locally follow these steps

```bash
Clone this repo

bundle install

# Setup database.yml, use database.yml.example as guide

rails db:migrate

rails credentials:edit #football_data_auth_token is needed to use the api

rails api:all
```

It is possible to simulate predictions for all users with

```bash
rails simulate:predictions
```

...and calculate points for all matches in one go with, otherwise this happens when each match gets updated.

```bash
rails simulate:calc_points
```

# TODO
One thing missing sorely is testing, I hope to start that soon.
Make sure everything is translated, and translated properly.
Add `scenic` and `fx` gems to handle views, triggers and functions in a better way.