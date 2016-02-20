class CreateFitbits < ActiveRecord::Migration
  def change
    create_table :fitbits do |t|
      t.string :name, null: false
      t.text :date, null: false
      t.datetime :last_update, null: false
      
      t.timestamps null: false
    end
  end
end
