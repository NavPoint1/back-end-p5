class AddLikesToGuides < ActiveRecord::Migration[6.0]
  def change
    add_column :guides, :likes, :integer, default: 0
  end
end
