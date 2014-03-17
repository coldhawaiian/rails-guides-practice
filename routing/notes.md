# [Rails Routing from the Outside In][page]

[page]: http://guides.rubyonrails.org/routing.html

### 2.3 Path and URL Helpers

Dynamically generated path and url helpers. For a given resource `resource`,
rails creates the following helpers:

* `<resource>_path` => `/<resource>`
* `<resource>_path(:id)` => `/<resource>/<id>`
* `new_<resource>_path` => `/<resources>/new`
* `edit_<resource>_path(:id)` => `/<resources>/<id>/edit`

Each of these helpers has a corresponding `<resource>_url` helper which
returns the same path prefixed with the current host, port and path prefix.

### 2.5 Singular Resources

Sometimes, you have a resource that clients always look up without referencing
an ID. For example, you would like `/profile` to always show the profile of the
currently logged in user. In this case, you can use a singular resource to map
`/profile` (rather than `/profile/:id`) to the `show` action:

```ruby
get 'profile' => 'users#show'
```
### 2.6 Controller Namespaces and Routing

### 2.7 Nested Resources

#### 2.7.1 Limits to Nesting

#### 2.7.2 Shallow Nesting

Declaring a nested route with `shallow: true`:

```ruby
resources :posts do
  resources :comments, shallow: true
end
```
is equivalent to declaring the routes like this:

```ruby
# GET  /posts/:post_id/comments     => index
# POST /posts/:post_id/comments     => create
# GET  /posts/:post_id/comments/new => new
resources :posts do
  resources :comments, only: [:index, :new, :create]
end

# GET     /comments/:id      => show
# PUT     /comments/:id      => update
# DELETE  /comments/:id      => destroy
# GET     /comments/:id/edit => edit
resources :comments, only: [:show, :edit, :update, :destroy]
```

## 2.8 Routing concerns

## 2.9 Creating Paths and URLs From Objects

The following are equivalent:

```erb
<%= link_to 'Ad details', magazine_ad_path(@magazine, @ad) %>
<%= link_to 'Ad details', url_for([@magazine, @ad]) %>
<%= link_to 'Ad details', [@magazine, @ad] %>
```

For other actions, you just need to insert the action name as the first element
of the array:

```erb
<%= link_to 'Edit Ad', [:edit, @magazine, @ad] %>
```

If you wanted to link to just a magazine:

```erb
<%= link_to 'Magazine details', @magazine %>
```

These allows you to treat instances of your models as URLs, and is a key
advantage to using the resourceful style.

### 2.10 Adding More RESTful Actions

#### 2.10.1 Adding Member Routes

```ruby
resources :photos do
  # Adds "GET /photos/:id/preview" as a route
  member do
    get 'preview'
  end
  # Shorter syntax for individual route declarations
  get 'preview', on: :member
end
```

You can leave out the `:on` option, this will create the same member route
except that the resource id value will be available in `params[:photo_id]`
instead of `params[:id]`.

#### 2.10.2 Adding Collection Routes

```ruby
resources :photos do
  # Adds "GET /photos/search" as a route
  collection do
    get 'search'
  end
  # Shorter syntax for individual route declarations
  get 'search', on: :collection
end
```

## 3 Non-Resourceful Routes

### 3.5 Defining Defaults

### 3.6 Naming Routes

### 3.7 HTTP Verb Constraints

### 3.8 Segment Constraints

The following are equivalent:

```ruby
get 'photos/:id' => 'photos#show', constraints: { id: /[A-Z]\d{5}/ }
get 'photos/:id' => 'photos#show', id: /[A-Z]\d{5}/
```

### 3.9 Request-Based Constraints

### 3.10 Advanced Constraints

### 3.11 Route Globbing and Wildcard Segments

### 3.12 Redirection

```ruby
get '/stories' => redirect('/posts')
# Reusing dynamic segments from the match in the path to redirect to:
get '/stories/:name' => redirect('/posts/%{name}')
# Passing blocks
get '/stories/:name' => redirect { |params, request| "/posts/#{params[:name].pluralize}" }
get '/stories' => redirect { |params, request| "/posts/#{request.subdomain}" }
```

Please note that this redirection is a 301 "Moved Permanently" redirect. Keep in
mind that some web browsers or proxy servers will cache this type of redirect,
making the old page inaccessible.

In all of these cases, if you don't provide the leading host
(`http://www.example.com`), Rails will take those details from the current
request.

### 3.13 Routing to Rack Applications

### 3.14 Using `root`

You should put the root route at the top of the file, because it is the most
popular route and should be matched first.

## 4 Customizing Resourceful Routes

### 4.5 Prefixing the Named Route Helpers

### 4.6 Restricting the Routes Created

```ruby
resources :photos, only: [:index, :show]
resources :comments, except: :destroy
```

### 4.8 Overriding the Singular Form

```ruby
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'tooth', 'teeth'
end
```
## 5 Inspecting and Testing Routes
