class AddPublicTokenToForms < ActiveRecord::Migration[7.1]
  def change
    add_column :forms, :public_token, :string
    add_index :forms, :public_token, unique: true
    
    reversible do |dir|
      dir.up do
        Form.find_each do |form|
          form.update_column(:public_token, SecureRandom.urlsafe_base64(16))
        end
        
        change_column_null :forms, :public_token, false
      end
    end
  end
end
