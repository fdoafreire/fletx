require 'securerandom' 

puts "Iniciando....."

# ====================================================================
# 1. CREAR ROLES
# ====================================================================
puts "Creando roles..."
Role.find_or_create_by!(name: :admin)
Role.find_or_create_by!(name: :driver)
Role.find_or_create_by!(name: :user)

users_to_seed = {
  admin: { email: 'admin@fletx.com', role: :admin },
  driver: { email: 'driver@fletx.com', role: :driver }
}

users_to_seed.each do |key, data|
  user = User.find_or_initialize_by(email: data[:email])

  if user.new_record?
    puts "Creando usuario #{key}: #{data[:email]}"
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.jti = SecureRandom.uuid 

    if user.save
      user.add_role data[:role]
    else
      puts "ERROR al guardar el usuario #{key}: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "Usuario #{key} ya existe: #{data[:email]}"
    user.add_role data[:role] unless user.has_role? data[:role]
  end
  users_to_seed[key][:instance] = user 
end

# ====================================================================
# 3. CREAR REGISTROS ASOCIADOS (Driver)
# ====================================================================
driver_user = users_to_seed[:driver][:instance]

puts "Creando/Verificando registro de Driver asociado a #{driver_user.email}."
driver_record = Driver.find_or_create_by!(user_id: driver_user.id) do |driver|
  driver.license_number = 'DRV-12345'
  driver.status = 'available'
end

# ====================================================================
# 4. CREAR VEHÍCULO Y ASIGNARLO
# ====================================================================

puts "Creando/Verificando vehículo y asignándolo a Driver ID: #{driver_record.id}."
Vehicle.find_or_create_by!(
  driver: driver_record,
  license_plate: 'ABC-123'
) do |vehicle|
  vehicle.model = 'Foton Auman'
  vehicle.capacity_tons = 15.5
end

puts "...FIN"
