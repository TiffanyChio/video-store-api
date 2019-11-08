class Movie < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true
  has_many :rentals, dependent: :nullify
  has_many :customers, through: :rentals
  
  def decrease_inventory
    self.available_inventory -= 1
    self.save
  end
  
  def increase_inventory
    self.available_inventory += 1
    self.save
  end
  
  def in_stock
    if self.available_inventory == 0
      return nil
    end
    
    return self
  end
  
  def find_rentals(category)
    if category == "current"
      selected_rentals = self.rentals.select { |rental| rental.check_in_date == nil }
    elsif category == "past"
      selected_rentals = self.rentals.select { |rental| rental.check_in_date != nil }
    end
    
    customer_info = selected_rentals.map { |rental| 
      {
        customer_id: rental.customer.id,
        name: rental.customer.name,
        postal_code: rental.customer.postal_code,
        check_out_date: rental.check_out_date,
        due_date: rental.due_date
      }
    }
    
    return customer_info
  end
end
