class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :form, null: false, foreign_key: true
      t.string :question_text, null: false
      t.string :question_type, null: false, default: 'text'
      t.boolean :required, null: false, default: true
      t.boolean :fixed, null: false, default: false
      t.integer :position, null: false

      t.timestamps
    end

    add_index :questions, [:form_id, :position], unique: true
  end
end
