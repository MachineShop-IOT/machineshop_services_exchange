# MachineShop Services Exchange

This is a fork-able repo for users of MachineShop services to create a portal.

## Versions

This application uses the following versions of Ruby and Rails:
* Rails 3.2.12
* Ruby 1.9.3-p392

It is recommended to use [RVM](https://rvm.io/) to manage your Ruby versions.
```
$ cd /your/project/root
$ rvm ruby-1.9.3-p392@machineshop_services_exchange --create --rvmrc
```

## Dependencies

If you want to upload documents and images through the [Paperclip](https://github.com/thoughtbot/paperclip) gem, you will need the following external dependencies installed on your machine:
* [ImageMagick](http://www.imagemagick.org/)

## Getting Started

Set your application's token in config/initializers/secret_token.rb
Get a unique secret token:

```
$ rake secret
```

To get the app up and running, do the following:

```
$ bundle install
# update config/database.yml to use your settings
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
$ bundle exec rails s
```

To configure Zendesk, add your credentials to config/app_settings.yml:
* zen_user: #YOUR_USER @company.com/token
* zen_token: #YOUR_ZEN_TOKEN
* zen_submitter: #YOUR_ZEN_SUBMITTER ex: 123456789
* zen_url: #https://YOUR_COMPANY.zendesk.com/api/v2

## Deploy
Sample settings listed in config/deploy.rb were originally set up to work with Amazon EC2 and NGINX. Configuration will need to be adjusted, based on your specifications.
