module AuthenticationControllerHelpers
  def login_as(user)
    request.env['warden'] = stub(
      :authenticate! => true,
      :authenticated? => true,
      :user => user
    )
  end

  def stub_user
    FactoryGirl.create(:user)
  end

  def stub_editor
    FactoryGirl.create(:user, :permissions => ['signin','edit_fact'])
  end

  def login_as_stub_user
    login_as stub_user
  end

  def login_as_stub_editor
    login_as(stub_editor)
  end
end
RSpec.configuration.include AuthenticationControllerHelpers, :type => :controller

module AuthenticationFeatureHelpers
  def login_as(user)
    GDS::SSO.test_user = user
  end

  def stub_user
    FactoryGirl.create(:user)
  end

  def stub_editor
    FactoryGirl.create(:user, :permissions => ['signin','edit_fact'])
  end

  def login_as_stub_user
    login_as stub_user
  end

  def login_as_stub_editor
    login_as stub_editor
  end
end
RSpec.configuration.include AuthenticationFeatureHelpers, :type => :feature
