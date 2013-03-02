module DHTTP
  class Database
    attr_reader :server, :path, :username, :password, :port, :ssl
    
    def initialize(args)
      @server = args[:server]
      @path = args[:path]
      @username = args[:username] or ""
      @password = args[:password] or ""
      @ssl = args[:ssl] or false
      @port = args[:port] or (@ssl ? 443 : 80)
    end
    
    def views
      json = JSON Net::HTTP.get(@server, "/#{@path}/api/data/collections")
      json.map { |view_json| DHTTP::View.new(self, view_json) }
    end
    
    def to_s
      {
        :server => @server,
        :path => @path,
        :username => @username,
        :password => @password
      }.inspect
    end
  end
end