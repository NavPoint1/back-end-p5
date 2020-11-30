class AddLayoutToSlides < ActiveRecord::Migration[6.0]
  def change
    add_column :slides, :layout, :integer, default: 0
  end
end
