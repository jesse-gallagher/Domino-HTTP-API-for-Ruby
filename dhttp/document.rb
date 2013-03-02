module DHTTP
  class Document
    attr_reader :parent, :unid, :href, :noteid, :created, :modified, :authors, :form, :items
    
    def initialize(parent, json)
      @parent = parent
      @unid = json.delete("@unid")
      @href = json.delete("@href")
      @noteid = json.delete("@noteid")
      @created = Time.parse(json.delete("@created")["data"])
      @modified = Time.parse(json.delete("@modified")["data"])
      @authors = json.delete("@authors")
      @form = json.delete("@form")
      @items = json.clone.freeze
    end
    
    def [](item_name)
      val = @items[item_name]
      if val.is_a? Hash and val["type"] == "datetime"
        val["data"].is_a?(Array) ? val["data"].map { |dt| Time.parse(dt) } : Time.parse(val["data"])
      else
        val
      end
    end
    
    def method_missing(method_name, *args)
      super if args.length > 1
      self[method_name.to_s]
    end
  end
end