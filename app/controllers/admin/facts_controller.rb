class Admin::FactsController < Admin::AdminController

  before_filter :initialize_fact, :only => [:new, :create]
  before_filter :find_fact, :only => [:edit, :update, :destroy]
  
  load_and_authorize_resource :except => :index
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_facts_path, :alert => exception.message
  end

  def index
    @facts = Fact.asc(:slug)
  end

  def new
  end

  def create
    if @fact.save
      redirect_to admin_facts_path, :notice => "#{@fact.name} saved"
    else
      flash[:alert] = "Could not save fact"
      render :new
    end
  end

  def edit
  end

  def update
    if @fact.update_attributes(params[fact_params_key])
      redirect_to admin_facts_path, :notice => "#{@fact.name} updated"
    else
      flash[:alert] = "Could not update fact"
      render :edit
    end
  end

  def destroy
    if @fact.destroy
      redirect_to admin_facts_path, :notice => "#{@fact.name} deleted"
    else
      render :index, :alert => "Could not update fact"
    end
  end

  private

  def find_fact
    @fact = Fact.find params[:id]
  end

  def initialize_fact
    data_type = fact_params_key.to_s
    @fact = data_type.classify.constantize.new params[data_type]
  end

  def fact_params_key
    ['currency_fact', 'date_fact', 'numeric_fact'].each do |type|
      return type if params.has_key?(type) or params[:data_type] == type
    end
    return 'fact'
  end
end
