class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.timestamps
      t.string :text, null: false
      t.integer :poll_id, null: false
    end
  end
end
