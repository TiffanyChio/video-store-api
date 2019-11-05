class RentalsCheckOutDefaultRemove < ActiveRecord::Migration[5.2]
  def change
    remove_column :rentals, :check_out_date
    add_column :rentals, :check_out_date, :date
  end
end
