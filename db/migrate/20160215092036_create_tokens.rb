class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.text :access_token
      t.text :refresh_token
      t.integer :expire_time

      t.timestamps null: false
    end
  end
end
