module PostMaker
  module Presenters
    # Base class for presenters
    class Presenter
      # Find a suitable presenter for a language
      #
      # @param [String] lang Language
      # @return [Class] Presenter class (in PostMaker::Presenters module)
      def self.find(lang)
        PostMaker::Presenters.const_get(lang.capitalize)
      end

      # Constructor
      #
      # @param [Array[PostMaker::Item]] Array of items to present.
      def initialize(items)
        @items = items
      end

      # Export a summary of the list of items
      #
      # Usually is just a list of items' titles.
      #
      # @return [String] String representing the list of items.
      def summary
        raise NotImplementedError
      end

      # Export the full post containing all the items

      # @return [String] String representing the full post.
      def full
        raise NotImplementedError
      end
    end
  end
end
