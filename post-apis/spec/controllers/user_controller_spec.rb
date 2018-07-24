require 'rails_helper'

RSpec.describe UsersController, type: :controller do
		email = "rspec@gmail.com"
		password = "password"
	  user = User.find_by_email(email)
	  user = User.create({:email => email, :password => password, :password_confirmation => password, name: "rspec user" }) if user.blank?
		describe "with valid password" do
	    it "should return user info" do
	      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      get :show
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp["user"]["email"]).to eq(email)
	    end

	    it "should update user" do
	    	request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      new_name = "updated name"
	      params = {:user => {:name => new_name}}
	      put :update,:params => params
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp["user"]["name"]).to eq(new_name)
	    end
	  end

		describe "with invalid password" do
		    it "should return 401 while getting user info" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
		      get :show
		      expect(response.status).to eq(401)
		    end

		    it "should return 401 while updating user info" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
		      get :show
		      expect(response.status).to eq(401)
		    end
	  end
end
