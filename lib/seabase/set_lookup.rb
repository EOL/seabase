module Seabase
  # Finds data in a Set
  class SetLookup
    def initialize
      @set_hash = {}
      @contexts = Set.new
    end

    def [](index)
      @set_hash[index]
    end

    def keys
      @set_hash.keys
    end

    def add(index, value)
      if @set_hash.member?(index)
        unless context?(value)
          @set_hash[index].add(value)
          add_context(value)
        end
      else
        @set_hash[index] = Set.new([value])
      end
    end

    # It's not clear if this is still necessary, 
    # but logically it doesn't hurt.
    def context?(value)
      (value.class == TranscriptContext) &&
        @contexts.member?(value.set_lookup_hash)
    end

    def add_context(value)
      return unless value.class == TranscriptContext
      @contexts.add(value.set_lookup_hash)
    end
  end
end
