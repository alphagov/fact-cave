class AddUniqueIndexForFactSlugs < ActiveRecord::Migration
  def change
    add_index :facts, :slug, :unique => true
  end
end
