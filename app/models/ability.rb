class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud
    if user.permissions.include?('edit fact')
      can :crud, Fact
    end
  end
end
