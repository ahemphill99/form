class UpdateQuestionTypeColumn < ActiveRecord::Migration[7.1]
  def up
    change_column :questions, :question_type, :string
    
    # Update existing records to use new enum values
    execute <<-SQL
      UPDATE questions 
      SET question_type = CASE question_type
        WHEN 'choice' THEN 'select'
        ELSE question_type
      END
    SQL
  end

  def down
    # No need to change column type back since string is compatible
    execute <<-SQL
      UPDATE questions 
      SET question_type = CASE question_type
        WHEN 'select' THEN 'choice'
        ELSE question_type
      END
    SQL
  end
end
