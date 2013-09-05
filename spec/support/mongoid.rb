RSpec.configure do |config|
  config.before :suite do
    # Now that mongoid no longer has the autocreate_indexes config option,
    # we need to ensure that the indexes exist in the test databse (the 
    # geo lookup functions won't work without them)
    silence_stream(STDOUT) do
      Rails::Mongoid.create_indexes
    end
  end
end
