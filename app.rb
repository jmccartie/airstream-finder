require "rubygems"
require "bundler"
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'mail'
require 'redis'
require 'json'

require_relative 'parser'
require_relative 'mailer'

unless ENV["RACK_ENV"] == "production"
  File.readlines(".env").each do |line|
    values = line.split("=")
    ENV[values[0]] = values[1]
  end
end

Mail.defaults do
  if ENV["RACK_ENV"] == "production"
    delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  else
    delivery_method :smtp, {
      address: "127.0.0.1",
      port: 1025
    }
  end
end

REDIS =
  if ENV["REDISGREEN_URL"]
    Redis.new(url: ENV["REDISGREEN_URL"], driver: :hiredis)
  else
    Redis.new
  end

##
# Init with high price and search params against the post title
# `run` will search latest posts and mail if found
##

class App

  attr_accessor :min_price, :max_price, :search, :log

  def initialize(opts)
    @min_price = opts[:min_price].to_i
    @max_price = opts[:max_price].to_i
    @search = opts[:search]

    @log = Logger.new(STDOUT)
    log.level = Logger::INFO
  end

  def run
    log.info "Running..."
    entries = Parser.search(self.min_price, self.max_price, self.search)

    if entries.any?
      Mailer.new(entries).deliver
      log.info "Mail sent"
    else
      log.info "No entries found"
    end
  end

end

# Run the app
App.new(min_price: ENV["MIN_PRICE"], max_price: ENV["MAX_PRICE"], search: ENV["SEARCH"]).run