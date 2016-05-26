class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.timestamps
      t.integer :tag_id, null: false
      t.integer :tagged_url_id, null: false
    end
    add_index :taggings, [:tag_id, :tagged_url_id]
  end
end
