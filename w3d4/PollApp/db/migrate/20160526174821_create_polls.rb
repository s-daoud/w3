class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.timestamps
      t.string :title, null: false
      t.integer :author_id, null: false
    end
  end
end
