require 'rails_helper'

RSpec.describe User, type: :model do
  context "with valid inputs" do
  	user = User.first
    it "should create a user" do
    	new_user = User.create({:email => "new_email@gmail.com", :password => "password", :password_confirmation => "password", name: "rspec user" })
      expect(new_user.errors.messages).to be_empty
      user.destroy
    end

    it "has many posts" do
      expect(user).to respond_to(:posts)
    end
  end

  context "with invalid inputs" do
    it "create should raise exception" do
      begin
      	new_user = User.create({:email => "new_email@gmail.com", :password => "password" })
      	false
      rescue Exception => e
      	true
      end
    end
  end
end
