# BoletoIntermedium

This gem makes possible to generate Bank Intermedium's payment slips in ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'BoletoIntermedium'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install BoletoIntermedium

## Usage

In order to generate the bank's slips, you need first to initialize the gem's module with some initial configurations:

```ruby
BoletoIntermedium.configure do |config|
    config.account = "0000000" #Your account number
end
```

Then, you can generate the payment slips:

```ruby
boleto = Boleto.new(
    payment_slip:       1,         #YOUR control number (Integer)
    value_in_cents:     100,       #Value to be paid in cents (Integer)
    due_date:           Date.today #Due Date (Date)
)
```

To get the bar code:
```ruby
boleto.bar_code
```

To get the formatted digitable line:
```ruby
boleto.formatted_digitable_line
```

To get the non-formatted digitable line:
```ruby
boleto.digitable_line
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hamdan85/BoletoIntermedium.

