class ChangeFitbitData < ActiveRecord::Migration
  def change
    rename_column :fitbits, :date, :data
  end
end
