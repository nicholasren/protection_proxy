require File.expand_path('spec_helper.rb')
require 'rspec/given'

describe ProtectionProxy do
  class User
    attr_accessor :name, :email, :membership_level

    def initialize(name, email, membership_level)
      @name = name
      @email = email
      @membership_level = membership_level
    end
  end

  ProtectionProxy.writable(:owner, [:membership_level])
  ProtectionProxy.writable(:browser, [:name, :email])

  Given(:user) {User.new("Jim", "jim@somewhere.com", "Beginner")}

  context "when user is the owner role" do
    Given(:proxy){ProtectionProxy.create_proxy(user, :owner)}

    Then{user.name.should == "Jim"}

    context "when I change a writable attribute" do
      When { proxy.membership_level = "Advanced"}
      Then { proxy.membership_level.should == "Advanced"}
      end

    context "when I change a protected attribute" do
      When {proxy.name = "Joe" }
      Then {proxy.name.should == "Jim"}
      end
  end

  context "when user is the brower role" do
    Given(:proxy) {ProtectionProxy.create_proxy(user, :browser)}

    context "when I change a writable attribute" do
      When { proxy.name = "Joe" }
      Then { proxy.name.should == "Joe" }
    end

    context "when I change a writable attribute" do
      When { proxy.email= "joe@gmail.com" }
      Then { proxy.email.should == "joe@gmail.com" }
    end

    context "when I change a protected attribute" do
      When { proxy.membership_level = "SuperUser" }
      Then { proxy.membership_level.should == "Beginner" }
    end
  end
end
