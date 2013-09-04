RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner[:mongo_mapper].strategy = :truncation
  end    

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
