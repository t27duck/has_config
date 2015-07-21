# HasConfig

[![Build Status](https://travis-ci.org/t27duck/has_config.svg?branch=master)](https://travis-ci.org/t27duck/has_config)

When working with models in a large Rails project, you sometimes end up with "god objects" which start to be loaded down with several booleans, integers, and strings from select boxes that act as configuration options. As time goes on, you add more and more columns. As your database and user-base grows, adding even a single column more can bring your app to a hault during a deploy due to table locking or a slew of exceptions due to [issues and gotchas like this](https://github.com/rails/rails/issues/12330).

In an attempt to cut down on cluttering your model with boolean columns, `has_config` allows you to have a single column contain all configuration switches you could ever want. Adding another configuration option to a model no longer requires a migration to add a column. You can also contiue writing code as if the model had all of those indiviual attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_config

## Usage

Let's say we have a model called `Client` whose job is to hold the general information configuration for a client in a multi-tenant application. First, we need to add one column to the model to hold the configuration information. By default, the gem assumes the column's name is `configuration`, but you can change that (more on that later).

```ruby
class AddConfigurationToClients < ActiveRecord::Migration
  add_column :clients, :configuration, :text
end
```

We now want to make that column a serialized hash in our model and include the `HasConfig` module.

```ruby
class Client < ActiveRecord::Base
  serialize :configuration, Hash
  include HasConfig
end
```

If you are using PostgreSQL 9.2 or later, you can use the JSON data-type for the configuration column and not have to declare it as a serilaized attribute in the model as `ActiveRecord` will take care of that for you.

If you want to use a different column name, you may override the default by setting `self.configuration_column = 'other_column_name'` in the model.

Finally, we're going to tell our model what configuration it'll hold. We do this via the `has_config` method the module provides. For now, here's a sensory overload example. We'll go into detail in the next part.

```ruby
class Client < ActiveRecord::Base
  serialize :configuration, Hash
  include HasConfig
  has_config :primary_color, :string, default: 'green', group: :style
  has_config :secondary_color, :string, group: :style
  has_config :rate_limit, :integer, validations: { numericality: { only_integer: true } }
  has_config :category, :string, validations: { inclusion: { in: CATEGORIES } }
  has_config :active, :boolean, default: false
end
```

Let's look at the `has_config` signature first before we go any further:

```ruby
  has_config(key, type, default:nil, group:nil, validations:{})
```

At minimum, you must provide a `key` and `type`. The `key` is what you'll call this configuraiton item. The `type` can be either `:string`, `:integer`, or `:boolean`.

If a configuration item doesn't have a value, `nil` is returned by default. Or, you may provide your own default value with the `default` option.

If you have a series of configuraiton items are are related, you can organize them together with the `group` option.

To the app, each configuraiton item is like a pseudo attribute on the model. Modle attributes can have validations. Use the `validations` option to pass in a hash of options you'd normally pass into the `validates` method for a regular attribute on the model.

Ok, still with me? Back to our example...

Here, the `Client` model has five configuration items on it: `primary_color`, `secondary_color`, `rate_limit`, `category`, and `active`. So, knowing what you just learned above...

`primary_color` is a string with a default value of green and grouped in the "style" group of configuration options.

`secondary_color` is a string without a default. It too is in the "style" group.

`rate_limit` is an integer that validates its value is in fact, an integer.

`category` is a string that must be a value in the array `CATEGORIES`.

`active` is a boolean value with a default of `false`.

We can now access these configuration settings as if they were regular attributes on the model:

```irb
client = Client.new
client.default_color
=> "green"
client.secondary_color
=> nil
client.active
=> false
client.active?
=> false
client.active = '1' # Like if this was submitted from a form
=> '1'
client.active?
=> true
client.rate_limit = 3
=> 3
client.valid?
=> false
client.errors.full_messages
=> ["Category is not in the list"]
```

Everything acts pretty much as you'd expect it too do. Configurations that fail validations make the record invalid. Passing in '1', 'true', `true`, etc casts boolean values. Passing in an empty string for an integer config casts as `nil`.

Finally, you can access all configuration values under a specific group with the `configuration_for_group` method.

```irb
client.configuration_for_group(:style)
=> {primary_color: 'green', secondary_color: nil}
```

## Testing

Tests run using a PostgreSQL database called `has_config_test`. You should be able to just create a database named that and run `bundle exec rake test`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/has_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
