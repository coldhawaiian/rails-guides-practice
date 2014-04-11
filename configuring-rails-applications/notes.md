# Configuring Rails Applications

## 1 Locations for Initialization Code

Rails offers four standard spots to place initialization code:

* `config/application.rb`
* Environment-specific configuration files
* Initializers
* After-initializers

## 2 Running Code Before Rails

## 3 Configuring Rails Components

### 3.1 Rails General Configuration

### 3.2 Configuring Assets

### 3.3 Configuring Generators

### 3.4 Configuring Middleware

### 3.5 Configuring i18n

### 3.6 Configuring Active Record

### 3.7 Configuring Action Controller

### 3.8 Configuring Action Dispatch

### 3.9 Configuring Action View

### 3.10 Configuring Action Mailer

### 3.11 Configuring Active Support

### [3.12 Configuring a Database][database]

[database]: http://guides.rubyonrails.org/configuring.html#configuring-a-database

### 3.13 Connection Preference

### 3.14 Creating Rails Environments

### 3.15 Deploy to a subdirectory (relative url root)

## 4 Rails Environment Settings

Some parts of Rails can also be configured externally by supplying environment
variables. The following environment variables are recognized by various parts
of Rails:

* `ENV["RAILS_ENV"]` defines the Rails environment (production, development,
   test, and so on) that Rails will run under.

* `ENV["RAILS_RELATIVE_URL_ROOT"]` is used by the routing code to recognize URLs
   when you deploy your application to a subdirectory.

* `ENV["RAILS_CACHE_ID"]` and `ENV["RAILS_APP_VERSION"]` are used to generate
   expanded cache keys in Rails' caching code. This allows you to have multiple
   separate caches from the same application.

## 5 Using Initializer Files

## 6 Initialization events

### 6.1 `Rails::Railtie#initializer`

### 6.2 Initializers

## 7 Database pooling

