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
end
