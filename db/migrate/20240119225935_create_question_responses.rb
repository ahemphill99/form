class CreateQuestionResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :question_responses do |t|
      t.references :form_response, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :response

      t.timestamps
    end
  end
end
