require "rubygems"
require "json"
require "net/http"
require "time"

require "#{File.dirname(__FILE__)}/dhttp/database"
require "#{File.dirname(__FILE__)}/dhttp/view"
require "#{File.dirname(__FILE__)}/dhttp/viewentry"
require "#{File.dirname(__FILE__)}/dhttp/document"

module DHTTP

  def self.test
    Database.new(:server => "api.frostillic.us", :path => "tests/http.nsf")
  end
end