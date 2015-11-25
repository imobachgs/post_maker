require "optparse"
require "post_maker"
require "octokit"
require "date"

module PostMaker
  DEFAULT_DAYS = 21
  DEFAULT_USERS = %w(yast libyui)

  # Command Line Interface class
  #
  # Parse the command line arguments and runs the main method.
  class CLI
    attr_reader :file, :format, :lang, :end_date, :start_date

    # Constructor
    #
    # Defaults:
    #
    # * file:       use standard output.
    # * format:     summary.
    # * lang:       markdown.
    # * end_date:   today.
    # * start_date: 21 days ago.
    #
    # @param [String] argv Command line arguments
    def initialize(argv)
      opts = parse_options(argv)
      @file   = opts[:file]
      @format = opts[:format] || "summary"
      @lang   = opts[:lang]   || "markdown"
      @users  = opts[:users]  || DEFAULT_USERS
      @end_date   = opts[:end_date]   ? Date.parse(opts[:end_date])   : Date.today
      @start_date = opts[:start_date] ? Date.parse(opts[:start_date]) : @end_date - DEFAULT_DAYS
    end

    # Retrieve items from Github and build a blog post
    def run
      client = Octokit::Client.new(netrc: true)
      items = PostMaker::Item.find(client, @users, @start_date, @end_date)
      presenter_class = PostMaker::Presenters::Presenter.find(@lang)
      presenter = presenter_class.new(items)
      output = presenter.send(@format)
      if @file
        File.open(@file, "w+") { |f| f.puts output }
      else
        puts output
      end
    end

    private

    # Parse command line arguments
    #
    # @param [String] argv Command line arguments
    # @return [Hash]  Application configuration
    # @option :lang       Language to use (markdown or html)
    # @option :format     Blog post entry (summary or full)
    # @option :output     Output file
    # @option :start_date Period's start date
    # @option :end_date   Period's end date
    # @option :users      List of users to filter
    def parse_options(argv)
      opts = {}
      parser = OptionParser.new
      parser.banner = "Usage: post_maker [options]"
      parser.separator ""
      parser.on("-l", "--lang LANG", "Output language (markdown or html)") do |lang|
        opts[:lang] = lang
      end
      parser.on("-f", "--format FORMAT", "Output format (summary or full)") do |format|
        opts[:format] = format
      end
      parser.on("-o", "--output FILE", "Output file (standard output by default)") do |file|
        opts[:file] = file
      end
      parser.on("-s", "--start DATE", "Start date (format YYYY-MM-DD)") do |date|
        opts[:start_date] = date
      end
      parser.on("-e", "--end DATE", "End date (format YYYY-MM-DD)") do |date|
        opts[:end_date] = date
      end
      parser.on("-u", "--users USERS", "List of users separated by commas to filter") do |users|
        opts[:users] = users.split(",").map(&:chomp)
      end
      parser.on_tail("-h", "--help", "Display help") do
        puts parser
        exit
      end

      begin
        parser.parse!(argv)
      rescue
        puts parser
        exit 1
      end

      opts
    end
  end
end
