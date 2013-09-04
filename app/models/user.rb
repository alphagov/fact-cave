class User
  include MongoMapper::Document

  key :uid, String
  key :email, String
  key :name, String
  key :permissions, Array
  key :remotely_signed_out, Boolean
  timestamps!

  include GDS::SSO::User
  
  attr_accessible :uid, :email, :name, :permissions, as: :oauth

  def to_s
    name
  end
end
