require 'rails_helper'

RSpec.describe Post, type: :model do
  context "with valid inputs" do
  	user = User.first
    it "should create a post with valid inputs" do
      post = user.posts.create!(:title => "test_title",:url => "test_url")
      expect(post.errors.messages).to be_empty
    end

    it "should belong a user" do
      post = user.posts.create!(:title => "test_title",:url => "test_url")
      expect(post.user).to eq(user)
    end
  end

  context "with invalid inputs" do
  	user = User.first
    it "create should raise exception" do
      begin
      	post = user.posts.create(:url => "test_url")
      	false
      rescue Exception => e
      	true
      end
    end
  end
end
