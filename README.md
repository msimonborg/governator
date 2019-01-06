![Governator](https://github.com/msimonborg/governator/blob/master/governator.png)

Scraper for data on US Governors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'governator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install governator

## Usage

```ruby
Governator.scrape! # or Governator.governate!

governors = Governator.governors
```

## Twitter

If you want to scrape Twitter for Twitter handles (recommended for best data results) you will need to initialize the client. Add this to your code (in a Rails app it should probably go in a file called `governator.rb` in `./config/initializers/`).

```ruby
Governator.config do |config|
  config.use_twitter = true

  config.twitter do |twitter|
    twitter.consumer_key        = YOUR_TWITTER_CONSUMER_KEY
    twitter.consumer_secret     = YOUR_TWITTER_CONSUMER_SECRET
    twitter.access_token        = YOUR_TWITTER_ACCESS_TOKEN
    twitter.access_token_secret = YOUR_TWITTER_ACCESS_TOKEN_SECRET
  end
end
```
More info can be found [here](https://github.com/sferik/twitter#configuration). When configured you can access the full Twitter gem client API with `Governator.twitter_client`.

As with everything, secrets should never be stored anywhere public, like version control. Set these values as variables on your system.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msimonborg/governator.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
