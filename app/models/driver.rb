class Driver < ApplicationRecord
  belongs_to :user
  has_one :vehicle, dependent: :destroy
  validates :license_number, presence: true, uniqueness: true
  validates :status, presence: true
  
  enum :status, { available: 0, busy: 1, maintenance: 2 }
  
  scope :available_for_hire, -> { where(status: :available) }
end
