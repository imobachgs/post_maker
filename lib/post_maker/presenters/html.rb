require "kramdown"
require "post_maker/presenters/markdown"

module PostMaker
  module Presenters
    class Html
      def initialize(items)
        @presenter = PostMaker::Presenters::Markdown.new(items)
      end

      # Export a summary of the list of items
      #
      # @example List of items
      #
      #   <ul>
      #     <li>Title 1</li>
      #     <li>Title 2</li>
      #   </ul>
      #
      # @see PostMaker::Presenters::Presenter#summary
      def summary
        Kramdown::Document.new(@presenter.summary).to_html.chomp
      end

      # Export the full post containing all the items
      #
      # @example Full post containing all items
      #
      #   <h2 id="first-title">First title</h2>
      #
      #   <p>First body</p>
      #
      # @see PostMaker::Presenters::Presenter#full
      def full(header_level: 2)
        Kramdown::Document.new(@presenter.full(header_level: header_level)).to_html.chomp
      end
    end
	end
end
