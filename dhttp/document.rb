module DHTTP
  class Document
    attr_reader :parent, :unid, :href, :noteid, :created, :modified, :authors, :form, :items
    
    def initialize(parent, json)
      @parent = parent
      @unid = json.delete("@unid")
      @href = json.delete("@href")
      @noteid = json.delete("@noteid")
      @created = Time.parse(json.delete("@created"))
      @modified = Time.parse(json.delete("@modified"))
      @authors = json.delete("@authors")
      @form = json.delete("@form")
      @items = json.clone.freeze
    end
    
    def [](item_name)
      @items[item_name]
    end
    
    def method_missing(method_name, *args)
      super if args.length > 1
      self[method_name.to_s]
    end
  end
end