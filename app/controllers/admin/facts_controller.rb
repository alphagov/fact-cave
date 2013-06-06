class Admin::FactsController < Admin::AdminController

  def index
    @facts = Fact.order(:slug)
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
    @fact = Fact.find params[:id]
  end

  def update
    @fact = Fact.find params[:id]
    if @fact.update_attributes(params[:fact])
      redirect_to admin_facts_path, :notice => "#{@fact.name} updated"
    else
      flash[:alert] = "Could not update fact"
      render :edit
    end
  end

  def destroy
    @fact = Fact.find params[:id]
    if @fact.destroy
      redirect_to admin_facts_path, :notice => "#{@fact.name} deleted"
    else
      render :index, :alert => "Could not update fact"
    end
  end

end
