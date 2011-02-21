class TwitterHelper
  require 'twitter'

  def self.perform_search(query, pages = 10, result_type = "recent")
    statement_list = []

    search = Twitter::Search.new
    search.containing(query).language("en").result_type(result_type).no_retweets.per_page(100)

    pages.times do |x|
      puts "Receiving page #{x} of results..."
      search.fetch_next_page.try(:each) do |tweet|
        tweet.text.scan(/^#{query} (.*)/i) { |statement|
          statement_list << statement[0]
        }
      end
    end

    puts "Returned #{statement_list.count} results."
    statement_list
  end
end

