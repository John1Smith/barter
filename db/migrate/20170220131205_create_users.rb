class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :second_name
      t.date :date_bith
      t.string :photo_url
      t.text :description
      t.string :location
      t.string :phone

      t.timestamps null: false
    end
  end
end
