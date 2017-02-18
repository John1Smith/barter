class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :user_login
      t.string :password

      t.timestamps null: false
    end
  end
end
