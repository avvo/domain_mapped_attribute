# DomainMappedAttribute

This gem is an `ActiveRecord` extension to let you map string fields to associated domain data tables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'domain_mapped_attribute'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install domain_mapped_attribute

## Usage

Requiring the gem automatically enables the DSL for setting up domain mapping:

### Domain Tables

These are the tables of things to match against.

```ruby
class Restaurant < ActiveRecord::Base
  # this table has :id, :name, and timestamps
  domain_mappable :name # :name here is the column to match against
end
```

This enables you to resolve strings to ids (primary key) for building associations. The default resolver just uses a `where` clause against the attribute declared in the `domain_mappable` directive.

```ruby
Restaurant.resolve("McDonald's")
=> 2
```

### Mappable Tables

These are the tables that store the user inputted data as well as the association.

```ruby
class Review < ActiveRecord::Base
  # this table has :id, :restaurant_id, :restaurant_name
  belongs_to :restaurant
  domain_mapped_attribute :restaurant, Restaurant
end
```

When you set the `restaurant_name` attribute and try to save the record, we will use the `Restaurant` model to resolve it to an id and set the `restaurant_id` for the `restaurant` association.

### Customizing

You can customize the resolver to use when declaring the `domain_mappable` attribute.

```ruby
class Restaurant < ActiveRecord::Base
  domain_mappable :name, resolver_class: MyCustomResolver
end

class MyCustomResolver
  def initialize(*)
  end

  def resolve(name, options = {})
    # somehow return an id
  end
end
```

You can also customize the database columns of the user input and association.

```ruby
class Review < ActiveRecord::Base
  belongs_to :restaurant
  domain_mapped_attribute :restaurant, Restaurant, name_field: :establishment_name
                                                   id_field: :automapped_restaurant_id
end
```

This will operate on the `establishment_name` as the user input and set the `automapped_restaurant_id` instead of `restaurant_id`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/avvo/domain_mapped_attribute.
