# Active Support Core Extensions

## 1 How to Load Core Extensions

### 1.1 Stand-Alone Active Support

#### 1.1.1 Cherry-picking a Definition

```ruby
require 'active_support'
require 'active_support/core_ext/object/blank'
```

#### 1.1.2 Loading Grouped Core Extensions

```ruby
require 'active_support'
require 'active_support/core_ext/object'
```

#### 1.1.3 Loading All Core Extensions

```ruby
require 'active_support'
require 'active_support/core_ext'
```

#### 1.1.4 Loading All Active Support

```ruby
require 'active_support/all'
```

### 1.2 Active Support Within a Ruby on Rails Application

A Ruby on Rails application loads all Active Support unless
`config.active_support.bare` is `true`. In that case, the application will only
load what the framework itself cherry-picks for its own needs, and can still
cherry- pick itself at any granularity level, as explained in the previous
section.

## 10 Extensions to Array

### [10.3 Options Extraction][options]

[options]: http://guides.rubyonrails.org/active_support_core_extensions.html#options-extraction
