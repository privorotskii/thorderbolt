[![Build Status](https://travis-ci.org/TolichP/thorderbolt.svg?branch=master)](https://travis-ci.org/TolichP/thorderbolt) [![Test Coverage](https://api.codeclimate.com/v1/badges/2a3289492309d6f7740c/test_coverage)](https://codeclimate.com/github/TolichP/thorderbolt/test_coverage) [![Gem Version](https://badge.fury.io/rb/thorderbolt.svg)](https://badge.fury.io/rb/thorderbolt)

# Thorderbolt

`Thorderbolt` adds the ability to order `ActiveRecord` relation in an arbitrary order without having to store anything extra in the database.

It's as easy as:

```ruby
class User < ActiveRecord::Base
  extend Thorderbolt
end

User.order_as(name: ['John', 'Tom'])
=> #<ActiveRecord::Relation [
     #<User id: 3, name: 'John'>,
     #<User id: 1, name: 'Tom'>,
     #<User id: 2, name: 'Alex'>,
     #<User id: 4, name: 'Mike'>
   #]>
```

Order each specified field as equally is also supported.
In that case usual order will be applied for all satisfying condition records:

```ruby
User.order_as_any(name: ['John', 'Tom'])
=> #<ActiveRecord::Relation [
     #<User id: 1, name: 'Tom'>,
     #<User id: 3, name: 'John'>,
     #<User id: 2, name: 'Alex'>,
     #<User id: 4, name: 'Mike'>
   #]>
```

Using `thorderbolt` doesn't require any additional tables in DB.
Heavily inspired by [order_as_specified](https://github.com/panorama-ed/order_as_specified), but strongly refactored and some new features were added here.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thorderbolt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thorderbolt

## Usage

Actually, each example below is true for `order_as` and `order_as_any` methods. The difference is that `order_as` fixes ordering between specified records, when `order_as_any` just puts specified records at the top and don't set ordering between them at all.

Basic usage is simple:

```ruby
class User < ActiveRecord::Base
  extend Thorderbolt
end

User.order_as(name: ['John', 'Tom'])
=> #<ActiveRecord::Relation [
     #<User id: 3, name: 'John'>,
     #<User id: 1, name: 'Tom'>,
     #<User id: 2, name: 'Alex'>,
     #<User id: 4, name: 'Mike'>
   #]>
```

This returns all `Users`s in the given name order. Note that this
ordering is not possible with a simple `ORDER BY`. Magic!

Like any other `ActiveRecord` relation, it can be chained:

```ruby
User
  .where(name: ['John', 'Tom', 'Mike']).
  .order_as(name: ['John', 'Tom'])
  .limit(3)
=> #<ActiveRecord::Relation [
     #<User id: 3, name: 'John'>,
     #<User id: 1, name: 'Tom'>,
     #<User id: 4, name: 'Mike'>
   ]>
```

We can use chaining in this way to order by multiple attributes as well:

```ruby
User.
  order_as(name: ['John', 'Mike']).
  order_as(id: [4, 3, 5]).
  order(:updated_at)
=> #<ActiveRecord::Relation [

  # First is name 'John'...
     #<User id: 1, name: 'John', updated_at: '2020-08-01 02:22:00'>,

  # Within the name, we order by :updated_at...
     #<User id: 2, name: 'John', updated_at: '2020-08-01 07:29:07'>,

  # Then name 'Mike'...
     #<User id: 9, name: 'Mike', updated_at: '2020-08-03 04:11:26'>,

    # Within the name, we order by :updated_at...
     #<User id: 8, name: 'Mike', updated_at: '2020-08-04 18:52:14'>,

  # Then id 4...
     #<User id: 4, name: 'Alex', updated_at: '2020-08-01 12:59:33'>,

  # Then id 3...
     #<User id: 3, name: 'Tom', updated_at: '2020-08-02 19:41:44'>,

  # Then id 5...
     #<User id: 5, name: 'Tom', updated_at: '2020-08-02 22:12:52'>,

  # Then we order by :updated_at...
     #<User id: 7, name: 'Alex', updated_at: '2020-08-02 14:27:16'>,
     #<User id: 6, name: 'Tom', updated_at: '2020-08-03 14:26:06'>,
   ]>
```

We can also use this when we want to sort by an attribute in another model:

```ruby
User
  .joins(:city)
  .order_as(cities: { id: [first_city.id, second_city.id, third_city.id] })
```

In all cases, results with attribute values not in the given list will be
sorted as though the attribute is `NULL` in a typical `ORDER BY`:

```ruby
User.order_as(name: ['Tom', 'John'])
=> #<ActiveRecord::Relation [
     #<User id: 2, name: 'Tom'>,
     #<User id: 3, name: 'John'>,
     #<User id: 1, name: 'Mike'>,
     #<User id: 4, name: 'Mike'>
   ]>
```

Note that if a `nil` value is passed in the ordering an error is raised, because
databases do not have good or consistent support for ordering with `NULL` values
in an arbitrary order, so this behavior isn't permitted.

## Limitations

Databases may have limitations on the underlying number of fields you can have
in an `ORDER BY` clause. For example, in PostgreSQL if you pass in more than
1664 list elements you'll receive such error:

```ruby
PG::ProgramLimitExceeded: ERROR: target lists can have at most 1664 entries
```
That's a database limitation that this gem cannot avoid, unfortunately.

## Contributing

1. Fork it (https://github.com/TolichP/thorderbolt/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Please, make sure your changes have appropriate tests (`bundle exec rspec`) and conform to the Rubocop style specified.

## License

`Thorderbolt` is released under the [MIT License](https://github.com/TolichP/thorderbolt/blob/master/LICENSE.txt).