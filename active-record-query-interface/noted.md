# [Active Record Query Interface][source]

[source]: http://guides.rubyonrails.org/active_record_querying.html

Models used in the examples:

```ruby
class Client < ActiveRecord::Base
  has_one :address
  has_many :orders
  has_and_belongs_to_many :roles
end

class Address < ActiveRecord::Base
  belongs_to :client
end

class Order < ActiveRecord::Base
  belongs_to :client, counter_cache: true
end

class Role < ActiveRecord::Base
  has_and_belongs_to_many :clients
end
```

## 1.1 Retrieving a Single Object

```ruby
# Find the client with primary key (id) 10.
client = Client.find 10

# These 3 return nil when no record is found
client = Client.take
client = Client.first
client = Client.last

# Equivalent:
client = Client.find_by first_name: 'Lifo'
client = Client.where(first_name: 'Lifo').take

# These 4 return ActiveRecord::RecordNotFound when no record is found
client = Client.take!
client = Client.first!
client = Client.last!
client = Client.find_by! first_name: 'Lifo'
```

```sql
SELECT * FROM clients WHERE (clients.id = 10) LIMIT 1

SELECT * FROM clients LIMIT 1
SELECT * FROM clients ORDER BY clients.id ASC LIMIT 1
SELECT * FROM clients ORDER BY clients.id DESC LIMIT 1
```

## 1.2 Retrieving Multiple Objects

```ruby
# Find the clients with primary keys 1 and 10.
client = Client.find [1, 10]
client = Client.find(1, 10)
```

```sql
SELECT * FROM clients WHERE (clients.id IN (1,10))
```

## 1.3 Retrieving Multiple Objects in Batches

```ruby
# Inefficient when the users table has thousands of rows.
# Fetches **all** user records from the table into memory.
User.all.each do |user|
  NewsLetter.weekly_deliver user
end
```

Rails provides two methods that address this problem by dividing records into
memory-friendly batches for processing:

1. `find_each`, retrieves a batch of records and then yields each record to the
   block individually as a model.

2. `find_in_batches`, retrieves a batch of records and then yields the entire
   batch to the block as an array of models.

### 1.3.1 `find_each`

In the following example, `find_each` will **retrieve 1000 records (the current
default for both `find_each` and `find_in_batches`)** and then yield each record
individually to the block as a model. This process is repeated until all of the
records have been processed:

```ruby
User.find_each do |user|
  NewsLetter.weekly_deliver user
end
```

#### 1.3.1.1 Options for `find_each`

```ruby
User.find_each(batch_size: 5000) do |user|
  NewsLetter.weekly_deliver user
end

# Start processing from IDs >= 2000
User.find_each(start: 2000, batch_size: 5000) do |user|
  NewsLetter.weekly_deliver user
end
```

### 1.3.2 `find_in_batches`

```ruby
# Give add_invoices an array of 1000 invoices at a time
Invoice.find_in_batches(include: :invoice_lines) do |invoices|
  export.add_invoices invoices
end
```

## 2 Conditions

Conditions can either be specified as a string, array, or hash.

### 2.1 Pure String Conditions

```ruby
clients = Client.where "orders_count = '2'"
```

### 2.2 Array Conditions

```ruby
clients = Client.where("orders_count = ?", params[:orders])
clients = Client.where("orders_count = ? AND locked = ?", params[:orders], false)

# Placeholder Conditions
clients = Client.where ":start_date <= created_at AND created_at <= :end_date",
                        start_date: params[:start_date],
                        end_date: params[:end_date]
```

### 2.3 Hash Conditions

Only equality, range and subset checking are possible with Hash conditions.

```ruby
# Equality Conditions
clients = Client.where locked: true
clients = Client.where 'locked' => true

posts = Post.where author: author
authors = Author.joins(:posts).where(posts: { author: author })

# The values cannot be symbols. For example, you cannot do
# `Client.where(status: :active)`.

# Range Conditions
clients = Client.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)

# Subset Conditions (uses SQL IN expression)
clients = Client.where(orders_count: [1, 3, 5])
```

### 2.4 NOT conditions

```ruby
posts = Post.where.not(author: author)
```

## 3 Ordering

```ruby
clients = Client.order :created_at
clients = Client.order 'created_at'

clients = Client.order(created_at: :desc)
clients = Client.order(created_at: :asc)
clients = Client.order 'created_at DESC'
clients = Client.order 'created_at ASC'

clients = Client.order(orders_count: :asc, created_at: :desc)
clients = Client.order(:orders_count, created_at: :desc)
clients = Client.order 'orders_count ASC, created_at DESC'
clients = Client.order('orders_count ASC', 'created_at DESC')

# If you want to call `order` multiple times e.g. in different context, new
# order will append previous one

clients = Client.order("orders_count ASC").order("created_at DESC")
```

## 4 Selecting Specific Fields

```ruby
clients = Client.select('viewable_by, locked')
```

Be careful because this also means you're initializing a model object with only
the fields that you've selected. If you attempt to access a field that is not in
the initialized record you'll receive:

```
ActiveModel::MissingAttributeError: missing attribute: <attribute>
```

```ruby
# No duplicate names
query = Client.select(:name).distinct

# Remove distinct clause, can return duplicates
query.distinct(false)
```

## 5 Limit and Offset

`offset` is used to skip `n` records before retrieving.

```ruby
clients = Client.limit(5).offset(30)
```

## 6 Group

```ruby
orders = Order.select('date(created_at) as order_date, sum(price) as total_price')
              .group('date(created_at)')
```

## 7 Having

```ruby
orders = Order.select('date(created_at) as ordered_date, sum(price) as total_price')
              .group('date(created_at)').having('sum(price) > ?', 100)
```

## 8 Overriding Conditions

```ruby
# Overrides the ORDER BY clause
posts = Post.where('id > 10').limit(20).order('id asc').except(:order)
```

## 9 Null Relation

## 10 Readonly Objects

## 11 Locking Records for Update

## 12 Joining Tables

Using `joins` without an explicit select will return readonly records.

### 12.1 Using a String SQL Fragment

```ruby
Client.joins('LEFT OUTER JOIN addresses ON addresses.client_id = clients.id')
```

```sql
SELECT clients.* FROM clients
  LEFT OUTER JOIN addresses ON addresses.client_id = clients.id
```

### 12.2 Using Array/Hash of Named Associations

```ruby
class Category < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :category
  has_many :comments
  has_many :tags
end

class Comment < ActiveRecord::Base
  belongs_to :post
  has_one :guest
end

class Guest < ActiveRecord::Base
  belongs_to :comment
end

class Tag < ActiveRecord::Base
  belongs_to :post
end
```

#### 12.2.1 Joining a Single Association

```ruby
Category.joins(:posts)
```

```sql
SELECT categories.* FROM categories
  INNER JOIN posts ON posts.category_id = categories.id
```

#### 12.2.2 Joining Multiple Associations

```ruby
Post.joins(:category, :comments)
```

```sql
SELECT posts.* FROM posts
  INNER JOIN categories ON posts.category_id = categories.id
  INNER JOIN comments ON comments.post_id = posts.id
```

#### 12.2.3 Joining Nested Associations (Single Level)

```ruby
Post.joins(comments: :guest)
```

```sql
SELECT posts.* FROM posts
  INNER JOIN comments ON comments.post_id = posts.id
  INNER JOIN guests ON guests.comment_id = comments.id
```

#### 12.2.4 Joining Nested Associations (Multiple Level)

```ruby
Category.joins(posts: [{comments: :guest}, :tags])
```

```sql
SELECT categories.* FROM categories
  INNER JOIN posts ON posts.category_id = categories.id
  INNER JOIN comments ON comments.post_id = posts.id
  INNER JOIN guests ON guests.comment_id = comments.id
  INNER JOIN tags ON tags.post_id = posts.id
```

### 12.3 Specifying Conditions on the Joined Tables

```ruby
time_range = (Time.now.midnight - 1.day)..Time.now.midnight

Client.joins(:orders).where('orders.created_at' => time_range)
# Or
Client.joins(:orders).where(orders: { created_at: time_range })
```

## 13 Eager Loading Associations

```ruby
# N + 1 queries
clients = Client.limit(10)

clients.each do |client|
  puts client.address.postcode
end

# Eager-loading
clients = Client.includes(:address).limit(10)

clients.each do |client|
  puts client.address.postcode
end
```

```sql
SELECT * FROM clients LIMIT 10;
SELECT addresses.* FROM addresses
  WHERE (addresses.client_id IN (1,2,3,4,5,6,7,8,9,10));
```

### 13.1 Eager Loading Multiple Associations

#### 13.1.1 Array of Multiple Associations

```ruby
Post.includes(:category, :comments)
```

#### 13.1.2 Nested Associations Hash

```ruby
Category.includes(posts: [{comments: :guest}, :tags]).find(1)
```

### 13.2 Specifying Conditions on Eager Loaded Associations

Even though Active Record lets you specify conditions on the eager loaded
associations just like `joins`, the recommended way is to use joins instead.

However if you must do this, you may use `where` as you would normally.

```ruby
Post.includes(:comments).where("comments.visible" => true)
```

This would generate a query which contains a `LEFT OUTER JOIN` whereas the
`joins` method would generate one using the `INNER JOIN` function instead.

```sql
SELECT "posts"."id" AS t0_r0, ... "comments"."updated_at" AS t1_r5
FROM "posts" LEFT OUTER JOIN "comments" ON "comments"."post_id" = "posts"."id"
WHERE (comments.visible = 1)
```

## 14 Scopes

```ruby
class Post < ActiveRecord::Base
  scope :published, -> { where(published: true) }
end

# Equivalent to
class Post < ActiveRecord::Base
  def self.published
    where(published: true)
  end
end

# Chainable scopes
#-----------------

class Post < ActiveRecord::Base
  scope :published,               -> { where(published: true) }
  scope :published_and_commented, -> { published.where("comments_count > 0") }
end

# Usage
Post.published

category = Category.first
category.posts.published

# With arguments
#---------------

class Post < ActiveRecord::Base
  scope :created_before, ->(time) { where("created_at < ?", time) }
end

# Equivalent to

class Post < ActiveRecord::Base
  def self.created_before(time)
    where("created_at < ?", time)
  end
end

# Merging scopes
#---------------

class User < ActiveRecord::Base
  scope :active, -> { where state: 'active' }
  scope :inactive, -> { where state: 'inactive' }
end

User.active.inactive
# SELECT "users".* FROM "users"
# WHERE "users"."state" = 'active' AND "users"."state" = 'inactive'

User.active.where(state: 'finished')
# SELECT "users".* FROM "users"
# WHERE "users"."state" = 'active' AND "users"."state" = 'finished'

# `Relation#merge` can be used to override with the last clause
User.active.merge(User.inactive)
# SELECT "users".* FROM "users" WHERE "users"."state" = 'inactive'

# Applying a default scope for all queries
#-----------------------------------------

class Client < ActiveRecord::Base
  default_scope { where("removed_at IS NULL") }
end

# Alternate definition
class Client < ActiveRecord::Base
  def self.default_scope
    # Should return an ActiveRecord::Relation.
  end
end

# Removing All Scoping
#---------------------

Client.unscoped.load

# Chaining scopes with `unscoped`

Client.unscoped do
  Client.created_before(Time.zone.now)
end
```

## 15 Dynamic Finders

## 16 Find or Build a New Object

```ruby
Client.find_or_create_by(first_name: 'Andy')
```

```sql
SELECT * FROM clients WHERE (clients.first_name = 'Andy') LIMIT 1
BEGIN
  INSERT INTO clients (created_at, first_name, locked, orders_count, updated_at)
  VALUES ('2011-08-30 05:22:57', 'Andy', 1, NULL, '2011-08-30 05:22:57')
COMMIT
```

Find the client named "Andy", or if that client doesn't exist, create a client
named "Andy" which is not locked:

```ruby
Client.create_with(locked: false).find_or_create_by(first_name: 'Andy')
# or
Client.find_or_create_by(first_name: 'Andy') { |c| c.locked = false }
# or
Client.find_or_create_by(first_name: 'Andy') do |c|
  c.locked = false
end

# `find_or_initialize_by`
#------------------------

nick = Client.find_or_initialize_by(first_name: 'Nick')

nick.persisted?
# => false

nick.new_record?
# => true

nick.save
# => true
```

## 17 Finding by SQL

```ruby
Client.find_by_sql("SELECT * FROM clients
  INNER JOIN orders ON clients.id = orders.client_id
  ORDER clients.created_at desc")

# Returns an array of hashes, representing records
#-------------------------------------------------

Client.connection.select_all("SELECT * FROM clients WHERE id = '1'")

# Returns array of values of the specified columns
#-------------------------------------------------

Client.where(active: true).pluck(:id)
# SELECT id FROM clients WHERE active = 1
# => [1, 2, 3]

Client.distinct.pluck(:role)
# SELECT DISTINCT role FROM clients
# => ['admin', 'member', 'guest']

Client.pluck(:id, :name)
# SELECT clients.id, clients.name FROM clients
# => [[1, 'David'], [2, 'Jeremy'], [3, 'Jose']]

# `pluck` makes it possible to replace code like
Client.select(:id).map { |c| c.id }
Client.select(:id).map(&:id)
Client.select(:id, :name).map { |c| [c.id, c.name] }

# with
Client.pluck(:id)
Client.pluck(:id, :name)
```

Unlike `select`, `pluck` directly converts a database result into a Ruby Array,
without constructing ActiveRecord objects. This can mean better performance for
a large or often-running query.

Furthermore, unlike `select` and other `Relation` scopes, `pluck` triggers an
immediate query, and thus cannot be chained with any further scopes, although it
can work with scopes already constructed earlier:

```ruby
Client.pluck(:name).limit(1)
# => NoMethodError: undefined method `limit' for #<Array:0x007ff34d3ad6d8>

Client.limit(1).pluck(:name)
# => ["David"]
```

### 17.3 `ids`

```ruby
Person.ids
# SELECT id FROM people

class Person < ActiveRecord::Base
  self.primary_key = "person_id"
end

Person.ids
# SELECT person_id FROM people
```

## 18 Existence of Objects

```ruby
Client.exists?(1)
# Returns `true` if *any* record exists with the passed ids
Client.exists?(1,2,3)
Client.exists?([1,2,3])

Client.where(first_name: 'Ryan').exists?
Client.exists?

# via a model
Post.any?
Post.many?

# via a named scope
Post.recent.any?
Post.recent.many?

# via a relation
Post.where(published: true).any?
Post.where(published: true).many?

# via an association
Post.first.categories.any?
```

## 19 Calculations

```ruby
Client.count
# SELECT count(*) AS count_all FROM clients

Client.where(first_name: 'Ryan').count
# SELECT count(*) AS count_all
# FROM clients
# WHERE (first_name = 'Ryan')

Client.includes("orders")
      .where(first_name: 'Ryan', orders: {status: 'received'})
      .count

# SELECT count(DISTINCT clients.id) AS count_all
# FROM clients LEFT OUTER JOIN orders ON orders.client_id = client.id
# WHERE (clients.first_name = 'Ryan' AND orders.status = 'received')
```

## 20 Running EXPLAIN

