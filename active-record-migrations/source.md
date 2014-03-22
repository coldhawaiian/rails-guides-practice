# ActiveRecord::ConnectionAdapters::SchemaStatements

Path: `activerecord/lib/active_record/connection_adapters/abstract/schema_statements.rb`.

* [`create_table(table_name, options = {})`][create-table-api],
  [source][create-table-source]

  ```ruby
  def create_table(table_name, options = {})
    td = create_table_definition table_name, options[:temporary], options[:options]

    # Add a primary key column unless specified otherwise
    unless options[:id] == false
      # Use options[:primary_key], or default to 'id'
      pk = options.fetch(:primary_key) do
        Base.get_primary_key table_name.to_s.singularize
      end

      # Add a primary-key to the table definition.
      td.primary_key pk, options.fetch(:id, :primary_key), options
    end

    yield td if block_given?

    if options[:force] && table_exists?(table_name)
      drop_table(table_name, options)
    end

    execute schema_creation.accept td
    td.indexes.each_pair { |c,o| add_index table_name, c, o }
  end

  def native_database_types
    {}
  end

  private

  def create_table_definition(name, temporary, options)
    TableDefinition.new native_database_types, name, temporary, options
  end
  ```
* [`ActiveRecord::AttributeMethods::PrimaryKey#get_primary_key`][get-primary-key-source]

  ```ruby
  def get_primary_key(base_name) #:nodoc:
    return 'id' if base_name.blank?

    case primary_key_prefix_type
    when :table_name
      base_name.foreign_key(false)
    when :table_name_with_underscore
      base_name.foreign_key
    else
      if ActiveRecord::Base != self && table_exists?
        connection.schema_cache.primary_keys(table_name)
      else
        'id'
      end
    end
  end
  ```

* [`TableDefinition`][table-definition-api], [source][table-definition-source]

  ```ruby
  # Appends a primary key definition to the table definition.
  # Can be called multiple times, but this is probably not a good idea.
  def primary_key(name, type = :primary_key, options = {})
    column(name, type, options.merge(:primary_key => true))
  end

  def column(name, type, options = {})
    name = name.to_s
    type = type.to_sym

    if primary_key_column_name == name
      raise ArgumentError, "you can't redefine the primary key column '#{name}'. To define a custom primary key, pass { id: false } to create_table."
    end

    @columns_hash[name] = new_column_definition(name, type, options)
    self
  end

  def new_column_definition(name, type, options) # :nodoc:
    column = create_column_definition name, type
    limit = options.fetch(:limit) do
      native[type][:limit] if native[type].is_a?(Hash)
    end

    column.limit       = limit
    column.array       = options[:array] if column.respond_to?(:array)
    column.precision   = options[:precision]
    column.scale       = options[:scale]
    column.default     = options[:default]
    column.null        = options[:null]
    column.first       = options[:first]
    column.after       = options[:after]
    column.primary_key = type == :primary_key || options[:primary_key]
    column
  end

  private

  def create_column_definition(name, type)
    ColumnDefinition.new name, type
  end
  ```

[create-table-api]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-create_table
[create-table-source]: https://github.com/rails/rails/blob/v4.0.4/activerecord/lib/active_record/connection_adapters/abstract/schema_statements.rb#L173-L192
[table-definition-api]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html
[table-definition-source]: https://github.com/rails/rails/blob/v4.0.4/activerecord/lib/active_record/connection_adapters/abstract/schema_definitions.rb
[get-primary-key-source]: https://github.com/rails/rails/blob/v4.0.4/activerecord/lib/active_record/attribute_methods/primary_key.rb#L83-L98
