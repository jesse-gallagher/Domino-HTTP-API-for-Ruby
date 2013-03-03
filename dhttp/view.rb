module DHTTP
  class View < Base
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
    
    def entries
      ViewEntryCollection.new(self, "/collections/unid/#{@unid}?strongtype=true")
    end
  end
end