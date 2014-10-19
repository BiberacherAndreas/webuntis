# WebUntis

This gem makes calls to the [WebUntis][wu] JSON-RPC API.

## Installation

Add this line to your application's Gemfile:

    gem 'webuntis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webuntis

## Usage

Using it should be quite easy.  For example, to print a list of all active
teachers, you just do this:

``` ruby
require "webuntis"

wu = WebUntis.new("demo_inf",  "student", "", server="demo.webuntis.com")
wu.authorize
wu.teachers.each do |teacher|
  puts teacher["longName"] if teacher["active"]
end
```

## Contributing

1. Fork it ( https://github.com/nilsding/webuntis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[wu]: http://www.grupet.at/en/produkte/webuntis/uebersicht_webuntis.php