class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_signin_permission! 
end
