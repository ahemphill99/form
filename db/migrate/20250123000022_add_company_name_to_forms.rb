class AddCompanyNameToForms < ActiveRecord::Migration[8.0]
  def change
    add_column :forms, :company_name, :string
  end
end
