class CreateFormResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :form_responses do |t|
      t.references :form, null: false, foreign_key: true
      t.json :response_data
      t.string :status

      t.timestamps
    end
  end
end
