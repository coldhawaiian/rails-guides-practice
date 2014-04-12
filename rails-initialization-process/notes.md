# The Rails Initialization Process

## 1 Launch!

A Rails application is usually started by running `rails console` or
`rails server`.

### 1.1 `railties/bin/rails`

### 1.2 `railties/lib/rails/app_rails_loader.rb`

### 1.3 `bin/rails`

### 1.4 `config/boot.rb`

### 1.5 `rails/commands.rb`

### 1.6 `rails/commands/command_tasks.rb`

### 1.7 `actionpack/lib/action_dispatch.rb`

### 1.8 `rails/commands/server.rb`

### 1.9 Rack: `lib/rack/server.rb`

### 1.10 `config/application`

### 1.11 `Rails::Server#start`

### 1.12 `config/environment.rb`

### 1.13 `config/application.rb`

## 2 Loading Rails

### 2.1 `railties/lib/rails/all.rb`

### 2.2 Back to `config/environment.rb`

### 2.3 `railties/lib/rails/application.rb`

### 2.4 Rack: `lib/rack/server.rb`

