require "dhttp"

def test
  DHTTP::Database.new({ :server => "api.frostillic.us", :path => "tests/http.nsf" })
end