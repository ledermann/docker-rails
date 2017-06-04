class AddConfirmedAtToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :email_confirmation_token, :string
    add_column :users, :email_confirmed_at, :datetime

    User.update_all email_confirmed_at: Time.current
  end

  def down
    remove_column :users, :email_confirmation_token
    remove_column :users, :email_confirmed_at
  end
end
