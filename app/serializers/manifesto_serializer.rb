class ManifestoSerializer
  include JSONAPI::Serializer

  attributes :date, :status, :start_time, :end_time

  # CLAVE: Corrección de NameError usando :: (Namespace Global)
  belongs_to :driver, serializer: ::DriverSerializer 
  
  # CLAVE: Corrección de NameError usando ::
  belongs_to :vehicle, serializer: ::VehicleSerializer
  
  # CLAVE: Corrección de NameError usando ::
  has_many :stops, serializer: ::StopSerializer

  attribute :route_details do |manifesto|
    "Ruta de #{manifesto.stops.count} paradas."
  end
end
