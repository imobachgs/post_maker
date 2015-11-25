require_relative "spec_helper"
require "post_maker/item"
require "octokit"

RSpec.describe PostMaker::Item do
  describe ".find" do
    context "given a period" do
      let(:client) { Octokit::Client.new }

      let(:pull) do
        double("pull",
               title: "Some pull request",
               body: "A really nice description",
               url: "http://github.com/some")
      end

      let(:result) { double("result", items: [pull]) }

      it "returns one item for each pull request in the given period" do
        start_date = Date.parse("2015-11-20")
        end_date = Date.parse("2015-11-30")
        expect(client).to receive(:search_issues)
          .with("type:pr label:blog merged:2015-11-20..2015-11-30 user:yast", order: "asc")
          .and_return(result)
        items = described_class.find(client, %w(yast), start_date, end_date)
        expect(items[0].title).to eq(pull.title)
        expect(items[0].body).to eq(pull.body)
        expect(items[0].url).to eq(pull.url)
      end
    end
  end
end
