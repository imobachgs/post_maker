require_relative "../spec_helper"
require "post_maker/presenters"
require "post_maker/item"

RSpec.describe PostMaker::Presenters::Html do
  subject(:presenter) { described_class.new(items) }

  let(:items) { [item1, item2] }

  let(:item1) do
    PostMaker::Item.new("First title", "First body", "http://github.com/u/p/pulls/1")
  end

  let(:item2) do
    PostMaker::Item.new("Second title", "Second body", "http://github.com/u/p/pulls/2")
  end

  describe "#full" do
    context "given an empty list" do
      let(:items) { [] }

      it "returns an empty string" do
        expect(subject.full).to eq("")
      end
    end

    context "given one element" do
      let(:items) { [item1] }

      it "returns the concatenation of title and body using headline marks" do
        expect(subject.full).to eq(
          "<h2 id=\"first-title\">First title</h2>\n\n<p>First body</p>")
      end
    end

    context "given multiple elements" do
      let(:items) { [item1, item2] }

      it "returns all the items (title and body) concatenated and separated by '\n\n'" do
        expect(subject.full).to eq(
          "<h2 id=\"first-title\">First title</h2>\n\n<p>First body</p>\n\n" \
          "<h2 id=\"second-title\">Second title</h2>\n\n<p>Second body</p>"
        )
      end
    end

    context "given a header level" do
      let(:items) { [item1] }

      it "use given level in each header" do
        expect(subject.full(header_level: 3)).to eq(
          "<h3 id=\"first-title\">First title</h3>\n\n<p>First body</p>")
      end
    end
  end

  describe "#summary" do
    context "given an empty list" do
      let(:items) { [] }

      it "returns an empty string" do
        expect(subject.summary).to eq("")
      end
    end

    context "given multiple elements" do
      let(:items) { [item1, item2] }

      it "returns a markdown list containing all the titles" do
        expect(subject.summary).to eq(
          "<ul>\n  <li>First title</li>\n  <li>Second title</li>\n</ul>")
      end
    end
  end
end
