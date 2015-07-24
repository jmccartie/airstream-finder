require "rubygems"
require "bundler"
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'mail'
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

##
# Init with high price and search params against the post title
# `run` will search latest posts and mail if found
##

class App

  attr_accessor :price, :search, :log

  def initialize(opts)
    @price = opts[:price].to_i
    @search = opts[:search]

    @log = Logger.new(STDOUT)
    log.level = Logger::INFO
  end

  def run
    log.info "Running..."
    entries = Parser.search(self.price, self.search)

    if entries.any?
      Mailer.new(entries).deliver
      log.info "Mail sent"
    else
      log.info "No entries found"
    end
  end

end

App.new(price: ENV["PRICE"], search: ENV["SEARCH"]).run