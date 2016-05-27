class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.timestamps
      t.integer :answer_choice_id, null: false
      t.integer :respondent_id, null: false
    end
  end
end
