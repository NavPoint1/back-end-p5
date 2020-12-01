class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.string :name
      t.belongs_to :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
