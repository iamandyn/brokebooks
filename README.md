# README

## BrokeBooks
BrokeBooks is a Ruby on Rails Application developed by students at George Mason University for IT 390 Rapid Development of Scalable Applications in order practice and utilize Agile development and Scrum cycles. It is comprised of a frontend using Twitter's Bootstrap Framework and a Ruby on Rails backend. For development, a SQLite3 database is used for convenience sake, but production will use a PostgreSQL database.

### Ruby and Rails Version
Ruby v`2.5.1p57`

Rails v`5.2.1`

### Dependencies
BrokeBooks uses the rmagick gem, which has the following depedencies:
```
libmagick++-dev imagemagick
```

### Deployment
Run `bundle install --without production` for a development environment or just `bundle install` if it is for production. Run `rails db:migrate` to perform all database migrations and then `rails server` to start the server.
