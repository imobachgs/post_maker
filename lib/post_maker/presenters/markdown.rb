module PostMaker
  module Presenters
    class Markdown < Presenter
      HEADER_MARK = "#"

      # Export a summary of the list of items
      #
      # @example List of items
      #
      #   * Title 1
      #   * Title 2
      #
      # @see PostMaker::Presenters::Presenter#summary
      def summary
        @items.map { |i| "* #{i.title}" }.join("\n")
      end

      # Export the full post containing all the items
      #
      # @example Full post containing all items
      #
      #   ## Title 1
      #
      #   Body 1
      #
      #   ## Title 2
      #
      #   Body 2
      #
      # @see PostMaker::Presenters::Presenter#full
      def full(header_level: 2)
        parts = @items.map do |item|
          "#{HEADER_MARK * header_level} #{item.title}\n\n#{item.body}"
        end
        parts.join("\n\n")
      end
    end
  end
end
