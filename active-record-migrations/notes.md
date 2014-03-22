# 3 Writing a Migration

## 3.4 When Helpers aren't Enough

If the helpers provided by Active Record aren't enough you can use the `execute`
method to execute arbitrary SQL:

```ruby
Product.connection.execute('UPDATE `products` SET `price` = `free` WHERE 1')
```

For more details and examples of individual methods, check the API documentation.
In particular the documentation for:

* [ActiveRecord::ConnectionAdapters::SchemaStatements][schema] (which provides
  the methods available in the `change`, `up` and `down` methods),

* [ActiveRecord::ConnectionAdapters::TableDefinition][definition] (which
  provides the methods available on the object yielded by `create_table`), and

* [ActiveRecord::ConnectionAdapters::Table][table] (which provides the methods
  available on the object yielded by `change_table`).

[schema]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html
[definition]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html
[table]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/Table.html

# 7 Schema Dumping and You

## 7.1 What are Schema Files for?

There is no need (and it is error prone) to deploy a new instance of an app by
replaying the entire migration history. It is much simpler and faster to just
load into the database a description of the current schema.

# 8 Active Record and Referential Integrity
