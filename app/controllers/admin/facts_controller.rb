class Admin::FactsController < Admin::AdminController

  before_filter :find_fact, :only => [:edit, :update, :destroy]

  def index
    @facts = Fact.asc(:slug)
  end

  def new
    @fact = Fact.new
  end

  def create
    @fact = Fact.new params[:fact]
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
    if @fact.update_attributes(params[:fact])
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

end
