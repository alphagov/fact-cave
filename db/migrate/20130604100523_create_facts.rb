class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.string :name, :null => false
      t.string :slug, :null => false
      t.text :description, :null => false
      t.string :value, :null => false

      t.timestamps
    end
  end
end
