class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.timestamps
      t.integer :visitor_id, null: false
      t.integer :visited_url_id, null: false
    end
    add_index :visits, [:visitor_id, :visited_url_id]
  end
end
