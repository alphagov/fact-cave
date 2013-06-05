class Admin::FactsController < Admin::AdminController

  def index
    @facts = Fact.all
  end

  def new
    @fact = Fact.new
  end

  def create
    @fact = Fact.new params[:fact]
    if @fact.save
      redirect_to admin_facts_path, :message => "Fact saved"
    else
      render :edit, :alert => "Could not save fact"
    end
  end

  def edit
    @fact = Fact.find params[:id]
  end

  def update
    @fact = Fact.find params[:id]
    if @fact.update_attributes(params[:fact])
      redirect_to admin_facts_path, :message => "Fact updated"
    else
      render :edit, :alert => "Could not update fact"
    end
  end

  def destroy
    @fact = Fact.find params[:id]
    if @fact.destroy
      redirect_to admin_facts_path, :message => "Fact deleted"
    else
      render :index, :alert => "Could not update fact"
    end
  end

end
