module DHTTP
  class Database < Base
    attr_reader :server, :path, :username, :password, :port, :ssl
    
    def initialize(args)
      raise TypeError.new("Args must be a hash") if not args.is_a? Hash
      
      @server = args[:server] or raise "Missing :server parameter"
      @path = args[:path] or raise "Missing :path parameter"
      @username = args[:username] || ""
      @password = args[:password] || ""
      @ssl = args[:ssl] or false
      @port = args[:port] or (@ssl ? 443 : 80)
    end
    
    def views
      fetch_views! if @views.nil?
      @views
    end
    def get_view(title)
      fetch_views! if @views.nil?
      @views_by_title[title]
    end
    
    def to_s
      {
        :server => @server,
        :path => @path
      }.inspect
    end
    
    
    
    def fetch(path)
      uri = URI("http#{@ssl ? 's' : ''}://#{@server}:#{@port}/#{@path}/api/data#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Get.new(uri.request_uri)
      unless @username.empty?
        # TODO: make this actually work
        req.basic_auth @username, @password
      end
      http.request(req)
    end
    def fetch_json(path)
      JSON fetch(path).body
    end
    
    private
    
    def fetch_views!
      json = fetch_json("/collections")
      @views = []
      @views_by_title = {}
      json.each do |view_json|
        view = DHTTP::View.new(self, view_json)
        @views << view
        @views_by_title[view.title] = view
      end
    end
  end
end