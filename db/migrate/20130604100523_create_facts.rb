class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :value

      t.timestamps
    end
  end
end
