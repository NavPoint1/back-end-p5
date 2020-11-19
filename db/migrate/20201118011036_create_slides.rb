class CreateSlides < ActiveRecord::Migration[6.0]
  def change
    create_table :slides do |t|
      t.belongs_to :guide, null: false, foreign_key: true
      t.string :header
      t.text :content
      t.string :media

      t.timestamps
    end
  end
end
