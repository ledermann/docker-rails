class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.timestamps null: false
      t.string :email, null: false
      t.string :encrypted_password, limit: 128, null: false
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128, null: false
      t.boolean :is_admin, null: false, default: false
    end

    add_index :users, :email
    add_index :users, :remember_token

    User.create! email:    ENV.fetch('APP_ADMIN_EMAIL'),
                 password: ENV.fetch('APP_ADMIN_PASSWORD'),
                 is_admin: true
  end

  def down
    drop_table :users
  end
end
