class Admin::FactsController < Admin::AdminController

  before_filter :initialize_fact, :only => [:new, :create]
  before_filter :find_fact, :only => [:edit, :update, :destroy]

  after_filter  :log_created_fact, only: [:create]
  around_filter :log_updated_fact, only: [:update]
  after_filter  :log_destroyed_fact, only: [:destroy]

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

  def log_created_fact
    if @fact.persisted?
      msg = {"message" => "#{@fact.class} created at #{@fact.created_at}"}
      log_entry = {
        "@fields" => {
          "event_type" => "create"
        }.merge("fact_data" => extract_attrs_to_log).merge(msg)
      }
      write_log(log_entry)
    end
  end

  def log_updated_fact
    before_state = extract_attrs_to_log
    yield
    if @fact.valid?
      msg = "#{@fact.class} updated at #{@fact.updated_at}"
      log_entry =  {
        "@fields" => {
          "event_type" => "update",
          "fact_data" => {
            "before_state" => before_state,
            "changes" => extract_attrs_to_log.diff(before_state)
          },
          "message" => msg
        }
      }
      write_log(log_entry)
    end
  end

  def log_destroyed_fact
    if @fact.destroyed?
      before_state = extract_attrs_to_log
      msg = {"message" => "#{@fact.class} destroyed at #{DateTime.now}"}
      log_entry = {
        "@fields" => {
          "event_type" => "destroy"
        }.merge("fact_data" => before_state).merge(msg)
      }
      write_log(log_entry)
    end
  end

  def extract_attrs_to_log
    @fact.attributes.reject { |key, value|
      ["_id", "created_at", "updated_at"].include? key }
  end

  def write_log(entry)
    File.open("#{Rails.root}/log/#{Rails.env}.fact_audit.json.log", "a") {|f|
      f.puts entry.to_json }
  end
end
