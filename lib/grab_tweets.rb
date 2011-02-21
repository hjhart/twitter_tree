class TwitterHelper
  require 'twitter'

  def self.perform_search(query, result_type = "recent")
    statement_list = []

    search = Twitter::Search.new
    search.containing(query).language("en").result_type(result_type).no_retweets.per_page(100)

    15.times do |x|
      puts "Receiving page #{x} of results..."
      search.fetch_next_page.try(:each) do |tweet|
        tweet.text.scan(/#{query} (.*)/i) { |statement|
          statement_list << statement[0]
        }
      end
    end

    puts "Returned #{statement_list.count} results."
    
    counts = Hash.new{|h,k| h[k] = 0 }
    statement_list.each{|v| counts[v] += 1 }
    tree = Hash.new

    ap statement_list.sort
    ap counts.sort 
  end
end

