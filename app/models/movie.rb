class Movie < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true
  has_many :rentals
  has_many :customers, through: :rentals
  
  def decrease_inventory
    self.available_inventory -= 1
    self.save
  end
  
  def increase_inventory
    self.available_inventory += 1
    self.save
  end
end
