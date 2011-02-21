class TreeBuilder
  def initialize(sentences)
    sentences.each do |sentence|
      puts "Analyzing sentence"
      puts "\t#{sentence}"

      words = sentence.split(/\s+/)
      max_counter = 0

      TreeNode.find(:all, :conditions => ["name LIKE ?", "#{words.first}%"]).each do |node|

        matching_string = words.first

        counter = 0
        deepest_node = nil
        deepest_search_string = nil

        puts "Found a match at #{node.name} with id #{node.id}"

        while (node.name.starts_with?(matching_string) && counter < words.length - 1)
          puts "Found a match #{counter} iterations deep"
          counter += 1

          if counter >= max_counter
            puts "Awesome! New Node ID @ #{node.id} and #{matching_string}"
            max_counter = counter
            deepest_node = node.id
            deepest_search_string = matching_string
          end

          matching_string += " " + words[counter]
        end

        puts "The deepest node was at #{max_counter} words long. Creating that ID"
        puts "Updating TreeNode with ID: #{deepest_node} to #{deepest_search_string}"
        update_treenode = TreeNode.find(deepest_node)
        existing_sentence = update_treenode.name
        new_sentence = existing_sentence.gsub(deepest_search_string, "")
        update_treenode.update_attributes(:name => deepest_search_string)
        puts "Creating a TreeNode to replicate old tree node."
        TreeNode.create({:name => new_sentence, :parent_id => deepest_node})
        new_sentence = sentence.gsub(deepest_search_string, "")
        puts "Creating TreeNode with original sentence and new sentence, respectively"
        puts "\t#{sentence}"
        puts "\t#{new_sentence}"
        TreeNode.create({:name => new_sentence, :parent_id => deepest_node})
      end

      if max_counter == 0
        puts "No matches found. Creating a new TreeNode with sentence"
        puts "\t#{sentence}"
        root = TreeNode.find_or_create_by_name("root")
        TreeNode.create({:name => sentence, :parent_id => root.id})
      end

    end
  end
end