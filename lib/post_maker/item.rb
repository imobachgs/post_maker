module PostMaker
  # Item to be included in the blog post.
  #
  # The current implementation will use merged projects pull requests (PR).
  #
  # @see PostMaker::Item.find
  class Item
    DATE_FMT = "%Y-%m-%d" # Date format to use in the query string.
    BLOG_LABEL = "blog"   # Label to filter pull requests.

    attr_reader :title, :body, :url

    # Find all pull requests for a given user and period.
    #
    # It will find all pull requests which:
    #
    # * belong to a determined user,
    # * were merged in the given period
    # * and are tagged to be used in a post (BLOG_LABEL).
    #
    # @param [Octokit::Client] client     Octokit client.
    # @param [Array[String]]   users      Users to filter.
    # @param [Date]            start_date Period's start date.
    # @param [Date]            end_date   Period's end date.
    # @return [Array[Item]]    List of items to include in the post.
    def self.find(client, users, start_date, end_date)
      users.reduce([]) do |all, user|
        search = client.search_issues("type:pr label:#{BLOG_LABEL} "\
          "merged:#{start_date.strftime(DATE_FMT)}..#{end_date.strftime(DATE_FMT)} " \
          "user:#{user}", order: "asc")
        all += search.items.map { |i| Item.new(i.title, i.body, i.url) }
      end
    end

    # Constructor
    #
    # @param [String] title Title of the PR.
    # @param [String] title Body of the PR (markdown).
    # @param [String] url   URL of the PR.
    def initialize(title, body, url)
      @title = title
      @body = body
      @url = url
    end
  end
end
