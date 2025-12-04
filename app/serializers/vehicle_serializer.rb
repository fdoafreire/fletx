class VehicleSerializer
  include JSONAPI::Serializer

  attributes :id, :license_plate, :model, :capacity_tons, :status
end
