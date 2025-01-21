class ChangeQuestionTypeToInteger < ActiveRecord::Migration[7.1]
  def up
    # First create a temporary column
    add_column :questions, :question_type_int, :integer

    # Update the new column based on the old values
    Question.reset_column_information
    Question.find_each do |question|
      type_value = case question.read_attribute(:question_type)
        when 'text' then 0
        when 'textarea' then 1
        when 'number' then 2
        when 'select', 'choice' then 3
        when 'radio' then 4
        when 'checkbox' then 5
        when 'date' then 6
        when 'email' then 7
        else 0 # default to text
      end
      question.update_column(:question_type_int, type_value)
    end

    # Remove the old column and rename the new one
    remove_column :questions, :question_type
    rename_column :questions, :question_type_int, :question_type
  end

  def down
    # First create a temporary column
    add_column :questions, :question_type_str, :string

    # Update the new column based on the old values
    Question.reset_column_information
    Question.find_each do |question|
      type_value = case question.read_attribute(:question_type)
        when 0 then 'text'
        when 1 then 'textarea'
        when 2 then 'number'
        when 3 then 'select'
        when 4 then 'radio'
        when 5 then 'checkbox'
        when 6 then 'date'
        when 7 then 'email'
        else 'text'
      end
      question.update_column(:question_type_str, type_value)
    end

    # Remove the old column and rename the new one
    remove_column :questions, :question_type
    rename_column :questions, :question_type_str, :question_type
  end
end
