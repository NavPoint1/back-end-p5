class CreateSlideThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :slide_themes do |t|
      t.belongs_to :slide, null: false, foreign_key: true
      t.string :theme_belongs_to

      t.timestamps
    end
  end
end
