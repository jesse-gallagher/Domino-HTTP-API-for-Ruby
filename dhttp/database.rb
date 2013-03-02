module DHTTP
  class Database
    attr_reader :server, :path, :username, :password, :port, :ssl
    
    def initialize(args)
      @server = args[:server]
      @path = args[:path]
      @username = args[:username] || ""
      @password = args[:password] || ""
      @ssl = args[:ssl] or false
      @port = args[:port] or (@ssl ? 443 : 80)
    end
    
    def views
      json = fetch_json("/collections")
      json.map { |view_json| DHTTP::View.new(self, view_json) }
    end
    
    def fetch_json(path)
      uri = URI("http#{@ssl ? 's' : ''}://#{@server}:#{@port}/#{@path}/api/data#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      unless @username.empty?
        req.basic_auth @username, @password
      end
      res = http.request(req)
      JSON res.body
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