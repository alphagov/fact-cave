class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :email
      t.string :name
      t.text :permissions
      t.boolean :remotely_signed_out, :default => false
      t.timestamps
    end
  end
end
