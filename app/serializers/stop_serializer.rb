class StopSerializer
  include JSONAPI::Serializer

  attributes :address, :order, :stop_type, :status, :completed_at

  belongs_to :manifesto 
end
