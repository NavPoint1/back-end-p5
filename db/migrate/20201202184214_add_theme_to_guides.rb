class AddThemeToGuides < ActiveRecord::Migration[6.0]
  def change
    add_reference :guides, :theme, null: true, foreign_key: true
  end
end
