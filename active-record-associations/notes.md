## 2 The Types of Associations

### 2.4 The `has_many :through` Association

```ruby
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: :appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
  has_many :physicians, through: :appointments
end
```

The `has_many :through` association is also useful for setting up "shortcuts"
through nested `has_many` associations. For example, if a document has many
sections, and a section has many paragraphs, you may sometimes want to get a
simple collection of all paragraphs in the document. You could set that up this
way:

```ruby
class Document < ActiveRecord::Base
  has_many :sections
  has_many :paragraphs, through: :sections
end

class Section < ActiveRecord::Base
  belongs_to :document
  has_many :paragraphs
end

class Paragraph < ActiveRecord::Base
  belongs_to :section
end
```

With `through: :sections` specified, Rails will now understand:

```ruby
@document.paragraphs
```

### 2.7 Choosing Between `belongs_to` and `has_one`

### 2.8 Choosing Between `has_many :through` and `has_and_belongs_to_many`

### 2.9 Polymorphic Associations

### 2.10 Self Joins

```ruby
class Employee < ActiveRecord::Base
  belongs_to :manager, class_name: "Employee"
  has_many :subordinates, class_name: "Employee", foreign_key: "manager_id"
end
```
## 3 Tips, Tricks, and Warnings

Here are a few things you should know to make efficient use of Active Record
associations in your Rails applications:

* Controlling caching
* Avoiding name collisions
* Updating the schema
* Controlling association scope
* Bi-directional associations

### 3.5 Bi-directional Associations

```ruby
class Customer < ActiveRecord::Base
  has_many :orders, inverse_of: :customer
end

class Order < ActiveRecord::Base
  belongs_to :customer, inverse_of: :orders
end
```

There are a few limitations to `inverse_of` support:

* They do not work with `:through` associations.
* They do not work with `:polymorphic` associations.
* They do not work with `:as` associations.
* For `belongs_to` associations, `has_many` inverse associations are ignored.

## 4 Detailed Association Reference

### 4.4 `has_and_belongs_to_many` Association Reference

#### 4.4.2 Options for `has_and_belongs_to_many`

##### 4.4.2.1 `:association_foreign_key`

The `:foreign_key` and `:association_foreign_key` options are useful when
setting up a many-to-many self-join. For example:

```ruby
class User < ActiveRecord::Base
  has_and_belongs_to_many :friends,
    class_name: "User",
    foreign_key: "this_user_id",
    association_foreign_key: "other_user_id"
end
```
