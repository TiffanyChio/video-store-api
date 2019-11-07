class Customer < ApplicationRecord
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  has_many :rentals, dependent: :nullify
  has_many :movies, through: :rentals
  
  def add_to_checked_out
    self.movies_checked_out_count += 1
    self.save
  end
  
  def remove_checked_out
    self.movies_checked_out_count -= 1
    self.save
  end
end
