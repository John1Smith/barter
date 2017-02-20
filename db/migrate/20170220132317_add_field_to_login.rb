class AddFieldToLogin < ActiveRecord::Migration
  def change
	add_reference :logins, :user, index: true
  end
end
