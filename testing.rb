require "dhttp"

testdb = DHTTP::Database.new({ :server => "api.frostillic.us", :path => "tests/http.nsf" })