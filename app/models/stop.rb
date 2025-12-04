class Stop < ApplicationRecord
  enum :stop_type, { pickup: 0, delivery: 1, checkpoint: 2 }
  enum :status, { scheduled: 0, en_route: 1, completed: 2 }
  
  belongs_to :manifesto

  validates :order, presence: true, numericality: { greater_than: 0 }
  validates :address, presence: true
  
  def can_complete?
    scheduled? || en_route?
  end

  validates :order, uniqueness: { scope: :manifesto_id }
end
