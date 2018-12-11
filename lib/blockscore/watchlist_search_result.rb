module BlockScore
  class WatchlistSearchResults< Array
    def initialize(data, searched_lists:)
      super(Array.wrap(data))
      @searched_lists = searched_lists
    end

    def searched_lists
      @searched_lists
    end
  end
end
