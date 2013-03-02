module DHTTP
  class Base
    def to_s
      "#{self.class.to_s}"
    end
    def inspect
      self.to_s.inspect
    end
  end
end