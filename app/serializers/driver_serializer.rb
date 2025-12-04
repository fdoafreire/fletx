class DriverSerializer
  include JSONAPI::Serializer # O la gema que estés usando

  attributes :id, :license_number, :status 
  
  attribute :email do |driver|
    driver.user.email
  end
end
