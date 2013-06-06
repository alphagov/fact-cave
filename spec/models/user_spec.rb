require 'spec_helper'

describe User do
  before :each do
    @user = FactoryGirl.create(:user, 
                               :uid => '123factmeister',
                               :name => 'Factmeister General',
                               :email => 'factmeister@digital.cabinet-office.gov.uk',
                               :permissions => ['fact-whisperer'])
  end
  it "should have gds-sso attributes" do
    @user.uid.should == '123factmeister'
    @user.name.should == 'Factmeister General'
    @user.email.should == 'factmeister@digital.cabinet-office.gov.uk'
    @user.permissions.should == ['fact-whisperer']
  end
  
  describe "to string" do
    it "should return their name" do
      @user.to_s.should == "Factmeister General"
    end
  end
end
