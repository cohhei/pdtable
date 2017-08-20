# Pdtable

Pdtable is a [Pandas.DataFrame(Python)](https://pandas.pydata.org/)-like class that is expanded from CSV::Table. It has some Pandas.DataFrame-like methods, for example [read_csv](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.read_csv.html). Pdtable infers each column's classes as a `dtype`. And you can specify them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdtable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pdtable

## Usage

### Read CSV

You can read CSV with `Pdtable::Pdtable.new`.

```sh
$ cat test/csv/default.csv
date,datetime,integer,float,string
2017/01/01,2017/01/01T00:00:00,1,1.1,string1
2017-01-02,2017-01-02 00:00:00,2,2.2,string2
20170103,,3,3.3,"string3"
```

```ruby
> t = Pdtable::Pdtable.new 'test/csv/default.csv'
 => #<Pdtable::Pdtable mode:col_or_row row_count:4>

> puts t
date,datetime,integer,float,string
2017-01-01T00:00:00+00:00,2017-01-01T00:00:00+00:00,1,1.1,string1
2017-01-02T00:00:00+00:00,2017-01-02T00:00:00+00:00,2,2.2,string2
2017-01-03T00:00:00+00:00,,3,3.3,string3
 => nil

> t.to_a
 => [[:date, :datetime, :integer, :float, :string], [#<DateTime: 2017-01-01T00:00:00+00:00 ((2457755j,0s,0n),+0s,2299161j)>, #<DateTime: 2017-01-01T00:00:00+00:00 ((2457755j,0s,0n),+0s,2299161j)>, 1, 1.1, "string1"], [#<DateTime: 2017-01-02T00:00:00+00:00 ((2457756j,0s,0n),+0s,2299161j)>, #<DateTime: 2017-01-02T00:00:00+00:00 ((2457756j,0s,0n),+0s,2299161j)>, 2, 2.2, "string2"], [#<DateTime: 2017-01-03T00:00:00+00:00 ((2457757j,0s,0n),+0s,2299161j)>, nil, 3, 3.3, "string3"]]
```

### Options

```ruby
> t = Pdtable::Pdtable.new 'test/csv/default.csv', dtype: {date: Date, float: String}
 => #<Pdtable::Pdtable mode:col_or_row row_count:4>

> t.to_a
 => [[:date, :datetime, :integer, :float, :string], [#<Date: 2017-01-01 ((2457755j,0s,0n),+0s,2299161j)>, #<DateTime: 2017-01-01T00:00:00+00:00 ((2457755j,0s,0n),+0s,2299161j)>, 1, "1.1", "string1"], [#<Date: 2017-01-02 ((2457756j,0s,0n),+0s,2299161j)>, #<DateTime: 2017-01-02T00:00:00+00:00 ((2457756j,0s,0n),+0s,2299161j)>, 2, "2.2", "string2"], [#<Date: 2017-01-03 ((2457757j,0s,0n),+0s,2299161j)>, nil, 3, "3.3", "string3"]]

> t = Pdtable::Pdtable.new 'test/csv/default.csv', skiprows: 0
 => #<Pdtable::Pdtable mode:col_or_row row_count:3>

> puts t
date,datetime,integer,float,string
2017-01-02T00:00:00+00:00,2017-01-02T00:00:00+00:00,2,2.2,string2
2017-01-03T00:00:00+00:00,,3,3.3,string3
 => nil

> t = Pdtable::Pdtable.new 'test/csv/default.csv', skiprows: [1, 2]
 => #<Pdtable::Pdtable mode:col_or_row row_count:2>

> puts t
date,datetime,integer,float,string
2017-01-01T00:00:00+00:00,2017-01-01T00:00:00+00:00,1,1.1,string1
 => nil
```

### CSV::Table method
Of Course, you can use `CSV::Table` methods, and you can get `CSV::Table` instance with `table`.

```ruby
> t[0]
 => #<CSV::Row date:#<DateTime: 2017-01-01T00:00:00+00:00 ((2457755j,0s,0n),+0s,2299161j)> datetime:#<DateTime: 2017-01-01T00:00:00+00:00 ((2457755j,0s,0n),+0s,2299161j)> integer:1 float:1.1 string:"string1">

> t.mode
 => :col_or_row

> t.headers
 => [:date, :datetime, :integer, :float, :string]

> t.table
 => #<CSV::Table mode:col_or_row row_count:4>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kohei-kimura/pdtable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pdtable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kohei-kimura/pdtable/blob/master/CODE_OF_CONDUCT.md).
