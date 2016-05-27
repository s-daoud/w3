class CreateAnswerChoices < ActiveRecord::Migration
  def change
    create_table :answer_choices do |t|
      t.timestamps
      t.string :text, null: false
      t.integer :question_id, null: false
    end
  end
end
