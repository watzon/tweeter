# Tweeter

[![Travis](https://img.shields.io/travis/watzon/tweeter.svg)](https://travis.org/watzon/tweeter) ![Dependencies](https://shards.rocks/badge/github/watzon/tweeter/status.svg) ![Github search hit counter](https://img.shields.io/github/search/watzon/tweeter/goto.svg) ![license](https://img.shields.io/github/license/watzon/tweeter.svg)

Tweeter is a Crystal interface to the Twitter API and is heavily based off the wonderfully thurough [Twitter Ruby Gem](https://github.com/sferik/twitter) by [sferik](https://github.com/sferik).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  tweeter:
    github: watzon/tweeter
```

## Usage

Make sure to include the tweeter gem at the root of your application or wherever you need to access it's functionality.

```crystal
require "tweeter"
```

### Configuration

Configuration for Tweeter is very similar to that of the Twitter Ruby Gem. The Twitter API requires authentication via OAuth, so you'll first need to [register your application with Twitter](https://apps.twitter.com/) to receive a consumer_key and consumer_secret. You can also authenticate your current user to get an access_token and access_token_secret. __Make sure you set the correct access level.__

You can pass the values you receive as a block to `Tweeter::REST::Client.new`.

```crystal
client = Tweeter::REST::Client.new do |config|
  config.consumer_key        = "YOUR_CONSUMER_KEY"
  config.consumer_secret     = "YOUR_CONSUMER_SECRET"
  config.access_token        = "YOUR_ACCESS_TOKEN"
  config.access_token_secret = "YOUR_ACCESS_SECRET"
end
```

### Usage Examples

The project is still in development and until it has a stable API I will refrain from listing usage examples here. Feel free to look in the `specs` directory to see how things are done in the tests that have been written so far.

## Development

### v1.0.0 Progress

- [x] Authentication
- [x] Cursor Support
- [ ] Streaming Client
- [ ] REST Client
  - [x] Direct Messages (__sending not working yet__)
  - [x] Favorites
  - [x] Friends and Followers
  - [x] Help
  - [ ] Lists
  - [x] OAuth
  - [ ] Places and Geo
  - [ ] Saved Searches
  - [x] Search
  - [ ] Spam Reporting
  - [ ] Suggested Users
  - [x] Timelines
  - [x] Trends
  - [x] Tweets
  - [x] Undocumented Endpoints
  - [x] Users
- [ ] Complete Specs

## Contributing

Please make sure you have the latest version of Crystal installed before doing any development. As of now this shard is updated to work with `Crystal 0.24.1`. Please also run `crystal tool format` & `crystal spec` before commiting.

1. Fork it ( https://github.com/watzon/tweeter/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [watzon](https://github.com/watzon) Chris Watson - creator, maintainer
