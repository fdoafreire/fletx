class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :created_at 
  
  attribute :roles do |user|
    user.roles.map(&:name)
  end
end
