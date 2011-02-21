class TreeBuilder
  def initialize(sentences)
    sentences.each do |sentence|
      puts "Analyzing sentence"
      puts "\t#{sentence}"

      words = sentence.split(/\s+/)
      max_counter = 0
      deepest_node, deepest_search_string = nil

      TreeNode.find(:all, :conditions => ["name LIKE ?", "#{words.first}%"]).each do |node|

        matching_string = words.first

        counter = 0

        puts "Found a match at #{node.name} with id #{node.id}"

        while (node.name.starts_with?(matching_string) && counter < words.length - 1)
          puts "Found a match #{counter} iterations deep"
          counter += 1

          if counter >= max_counter
            max_counter = counter
            deepest_node = node.id
            deepest_search_string = matching_string
          end

          matching_string += " " + words[counter]
        end
      end

      puts "Max counter: #{max_counter}, Deepest_node: #{deepest_node}"
      if max_counter == 0 || deepest_node == nil
        puts "No matches found. Creating a new TreeNode with sentence"
        puts "\t#{sentence}"
        root = TreeNode.find_or_create_by_name("root")
        TreeNode.create({:name => sentence, :parent_id => root.id})
      else
        puts "Updating TreeNode with ID: #{deepest_node}"
        puts "\t#{deepest_search_string}"
        update_treenode = TreeNode.find(deepest_node)
        existing_sentence = update_treenode.name
        new_sentence = existing_sentence.gsub(deepest_search_string, "")
        update_treenode.update_attributes(:name => deepest_search_string)
        puts "Creating a TreeNode to complete the original sentence"
        puts "\t#{new_sentence}"
        TreeNode.create({:name => new_sentence, :parent_id => deepest_node}) unless new_sentence.strip.empty?
        new_sentence = sentence.gsub(deepest_search_string, "")
        puts "Creating TreeNode with original sentence and new sentence, respectively"
        puts "\t#{sentence}"
        puts "\t#{new_sentence}"
        TreeNode.create({:name => new_sentence, :parent_id => deepest_node})
      end

    end
  end

  def self.execute(query)
    require 'lib/grab_tweets.rb'
    array = ::TwitterHelper.perform_search(query)
    TreeBuilder.new(array)
  end
end