class Admin::AdminController < ApplicationController
  include GDS::SSO::ControllerMethods
  before_filter :authenticate_user!
  before_filter :require_signin_permission! 
end
