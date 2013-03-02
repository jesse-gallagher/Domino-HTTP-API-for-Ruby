module DHTTP
  class View
    attr_reader :parent, :title, :folder, :private, :modified, :unid, :href
    
    def initialize(parent, json)
      @parent = parent
      @title = json["@title"]
      @folder = json["@folder"]
      @private = json["@private"]
      @modified = Time.parse(json["@modified"])
      @unid = json["@unid"]
      @href = json["@href"]
    end
    
    def each_entry
      JSON(Net::HTTP.get(@parent.server, "/#{@parent.path}/api/data/collections/unid/#{@unid}")).each do |entry_json|
        yield DHTTP::ViewEntry.new(self, entry_json)
      end
    end
    def entries
      JSON(Net::HTTP.get(@parent.server, "/#{@parent.path}/api/data/collections/unid/#{@unid}")).map do |entry_json|
        DHTTP::ViewEntry.new(self, entry_json)
      end
    end
  end
end