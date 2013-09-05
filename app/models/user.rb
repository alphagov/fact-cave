class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, :type => String
  field :email, :type => String
  field :name, :type => String
  field :permissions, :type => Array
  field :remotely_signed_out, :type => Boolean

  include GDS::SSO::User
  
  attr_accessible :uid, :email, :name, :permissions, as: :oauth

  def to_s
    name
  end
end
