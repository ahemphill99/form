class AddCompletionMessageToForms < ActiveRecord::Migration[7.1]
  def change
    add_column :forms, :completion_message, :text, default: "Thank you for submitting the form!"
  end
end
