class TreeNodeController < ActionController::Base

  def view
    @tree = TreeNode.find(:all, :include => [ :children ])
  end
end
