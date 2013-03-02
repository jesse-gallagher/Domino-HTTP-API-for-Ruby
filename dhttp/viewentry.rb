module DHTTP
  class ViewEntry
    attr_reader :parent, :noteid, :siblings, :position, :form, :unid, :entryid, :href, :column_values
    
    def initialize(parent, json)
      @parent = parent
      @noteid = json.delete("@noteid")
      @siblings = json.delete("@siblings")
      @position = json.delete("@position")
      @form = json.delete("@form")
      @unid = json.delete("@unid")
      @entryid = json.delete("@entryid")
      @href = json.delete("@href")
      
      json.delete("@link")
      
      @column_values = json.clone.freeze
    end
    
    def document
      DHTTP::Document.new(@parent.parent, JSON(Net::HTTP.get(@parent.parent.server, "/#{@parent.parent.path}/api/data/documents/unid/#{@unid}")))
    end
  end
end