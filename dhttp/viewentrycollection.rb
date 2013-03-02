module DHTTP
  class ViewEntryCollection
    attr_reader :parent, :count
    
    def initialize(parent, path)
      @parent = parent
      @path = path

      res = @parent.parent.fetch(@path)
      range_nums = /items (\d+)-(\d+)\/(\d+)/.match(res["Content-Range"])
      
      @count = range_nums[3].to_i
      @fetched_index = range_nums[2].to_i
      @block_size = (@fetched_index - range_nums[1].to_i) + 1
      
      @cached_entries = []
      JSON(res.body).each do |entry_json|
        @cached_entries << ViewEntry.new(@parent, entry_json)
      end
    end
    
    def [](index)
      raise "Must be integer" if not index.is_a? Integer
      return nil if index > @count-1
      
      if index > @fetched_index
        # fetch in multiples of the original block size, just for good measure
        needed = index - @fetched_index
        leftover = needed % @block_size
        needed_entries = (needed / @block_size) * @block_size + (leftover > 0 ? @block_size : 0)
        
        @parent.parent.fetch_json("#{@path}&start=#{@fetched_index+1}&count=#{needed_entries}").each do |entry_json|
          @cached_entries << ViewEntry.new(@parent, entry_json)
        end
        
        @fetched_index += needed_entries
      end
      @cached_entries[index]
    end
    
    def each
      (0..@count-1).each do |index|
        yield self[index]
      end
      self
    end
    def map
      result = []
      self.each { |entry| result << yield(entry) }
      result
    end
  end
end