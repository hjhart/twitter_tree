class CreateTreeNodes < ActiveRecord::Migration
  def self.up
    create_table :tree_nodes do |t|
      t.integer :parent_id
      t.string :name
    end
  end

  def self.down
    drop_table :tree_nodes
  end
end
