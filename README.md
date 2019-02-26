# NycDotCctv

The goal of this Gem is to provide a lightweight way to stream live NYCDOT camera feeds

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nyc_dot_cctv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nyc_dot_cctv

## Usage

### Capturing an image
The public CCTV cameras accessed as individual `.jpg` images. When you have the ID of a CCTV, you can capture an image by running the following line:
```ruby
cctv_id = "259"
NycDotCctv.request_image(cctv_id)
```

This request will return a response that contains a hash with the following types
```json
{
  "body": "String",
  "requested_at": "Datetime",
  "status_code": "Integer",
  "uri": "URI"
}
```

The 'body' will contain the `.jpg` image returned from the CCTV camera
if the request was successful. The 'requested_at' time is the time that the
request was triggered. The 'status_code' is the HTTP response header returned from the request. The 'uri' is the url generated to make the request.

### Obtaining a CCTV ID
I'm working on a way to make this a bit easier, but right now there's a small process to obtain a CCTV ID

1) Navigate to https://nyctmc.org/multiview2.php
2) Select any cameras from the list that you're interested in
3) Click View
4) You should be viewing live CCTV footage from the selected cameras.
5) Hover over each camera individually, right-click and click 'Inspect'(if you're on Chrome).
6) Inspector should open up over an `img` tag. Look at the source and find the part where it says something like `/cctv254.jpg`. The `254` is the ID that you want to use

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nyc_dot_cctv. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NycDotCctv project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nyc_dot_cctv/blob/master/CODE_OF_CONDUCT.md).
