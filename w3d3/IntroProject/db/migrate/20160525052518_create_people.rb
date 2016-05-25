class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name, null:false
      t.timestamps
      t.integer :house_id
    end
  end
end
