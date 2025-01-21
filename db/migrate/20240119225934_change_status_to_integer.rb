class ChangeStatusToInteger < ActiveRecord::Migration[7.1]
  def up
    # First create a temporary column
    add_column :form_responses, :status_int, :integer

    # Update the new column based on the old values
    FormResponse.reset_column_information
    FormResponse.find_each do |response|
      status_value = case response.read_attribute(:status)
        when 'draft' then 0
        when 'submitted' then 1
        when 'approved' then 2
        when 'rejected' then 3
        else 0 # default to draft
      end
      response.update_column(:status_int, status_value)
    end

    # Remove the old column and rename the new one
    remove_column :form_responses, :status
    rename_column :form_responses, :status_int, :status
  end

  def down
    # First create a temporary column
    add_column :form_responses, :status_str, :string

    # Update the new column based on the old values
    FormResponse.reset_column_information
    FormResponse.find_each do |response|
      status_value = case response.read_attribute(:status)
        when 0 then 'draft'
        when 1 then 'submitted'
        when 2 then 'approved'
        when 3 then 'rejected'
        else 'draft'
      end
      response.update_column(:status_str, status_value)
    end

    # Remove the old column and rename the new one
    remove_column :form_responses, :status
    rename_column :form_responses, :status_str, :status
  end
end
