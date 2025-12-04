class Manifesto < ApplicationRecord
  enum :status, { pending: 0, started: 1, completed: 2, canceled: 3 }

  belongs_to :driver
  belongs_to :vehicle
  has_many :stops, -> { order(order: :asc) }, dependent: :destroy
  
  validates :date, presence: true
  validates :status, presence: true
  
  def can_start?
    pending?
  end

  def can_complete?
    started? && stops.all?(&:completed?)
  end
  
  def can_cancel?
    pending? || started?
  end

  def start!
    raise ActiveRecord::RecordInvalid.new(self) unless can_start?
    
    update!(
      status: :started, 
      start_time: Time.current
    )
  end

  def complete!
    raise ActiveRecord::RecordInvalid.new(self) unless can_complete?
    
    update!(
      status: :completed, 
      end_time: Time.current
    )
  end

  def cancel!
    raise ActiveRecord::RecordInvalid.new(self) unless can_cancel?
    
    update!(status: :canceled)
  end
end
