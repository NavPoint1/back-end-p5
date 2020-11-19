class CreateGuides < ActiveRecord::Migration[6.0]
  def change
    create_table :guides do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.integer :views, default: 0
      t.integer :hidden_score, default: 0

      t.timestamps
    end
  end
end
