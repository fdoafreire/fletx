class Vehicle < ApplicationRecord
  enum :status, { available: 0, in_transit: 1, maintenance: 2 }
  
  has_many :manifestos
  belongs_to :driver

  validates :license_plate, presence: true, uniqueness: true
end
