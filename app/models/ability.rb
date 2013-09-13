class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, :to => :crud
    if user.permissions.include?('edit_fact')
      can :crud, Fact
    end
  end
end
