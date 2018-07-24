require 'rails_helper'

RSpec.describe PostsController, type: :controller do
		email = "rspec@gmail.com"
		password = "password"
	  user = User.find_by_email(email)
	  user = User.create({:email => email, :password => password, :password_confirmation => password, name: "rspec user" }) if user.blank?
	  user.posts.create!({:title => "test title",:url => "test url"})
		describe "with valid password" do
	    it "should return user posts" do
	      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      get :index
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp.count).to be >= 1
	    end

	    it "should return a given post" do
	    	request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      params = {:id => user.posts.first.id}
	      get :show,:params => params
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp["post"]).not_to be_empty
	    end

	    it "should update a post" do
	    	request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      title = "updated title"
	      params = {:id => user.posts.first.id,:post => {:title => title}}
	      put :update,:params => params
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp["post"]["title"]).to eq(title)
	    end

	    it "should create a post" do
	    	request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,password)
	      title = "title"
	      url = "url"
	      params = {:post => {:title => title,:url => url}}
	      post :create,:params => params
	      resp = JSON.parse(response.body)
	      expect(response.status).to eq(200)
	      expect(resp["post"]["title"]).to eq(title)
	    end
	  end

		describe "with invalid password" do
		    it "should return 401 while getting all post" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
		      get :index
		      expect(response.status).to eq(401)
		    end

		    it "should return 401 while displaying a post" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
		      params = {:id => user.posts.first.id}
	      	get :show,:params => params
		      expect(response.status).to eq(401)
		    end

		    it "should return 401 while updating a post" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
		      params = {:id => user.posts.first.id,:post => {:title => "title"}}
	      	put :update,:params => params
		      expect(response.status).to eq(401)
		    end

		    it "should return 401 while creating a post" do
		      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(email,"wrong_password")
	      	params = {:post => {:title => "title",:url => "url"}}
	      	post :create,:params => params
		      expect(response.status).to eq(401)
		    end
	  end
end
