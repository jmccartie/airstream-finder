# Airstream Finder

Little app to parse and search for late model airstreams from AirstreamClassifieds.com

## Why?

I'm looking for an airstream. Friends tell me AirstreamClassifieds.com is my best bet. But the site is built on WordPress with no API or decent way to set up notifications. So this little app fills that gap.

## Setup

1. Add some ENV vars
2. Run the app

### ENV vars

See `.env-sample`. You'll need to rename that file to ".env" to get things running locally.  You'll need to set all of these vars in production.

### Running

Just run `ruby app.rb` whenever you want to check for new listings. Cron or Heroku Scheduler will do.

## License

(The MIT License)

Copyright (c) 2015 Jon McCartie

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.