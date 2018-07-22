class PostsController < ApplicationController
  
  before_action :authenticate_user!, :except => [:show,:index]
  before_action :set_post, :except => [:create,:index]

  def show
    render json: {post: {id: @post.id,title: @post.title,url: @post.url}}
  end
 
  def update
    if @post.update_attributes(post_params)
      render json: {post: {id: @post.id,title: @post.title,url: @post.url}}
    else
      render json: { errors: @post.errors }, status: :unprocessable_entity
    end
  end

  def create
    @post = current_user.posts.create(post_params)
    render json: {post: {id: @post.id,title: @post.title,url: @post.url}}
  end

  def index
    posts = Post.all
    if posts.blank?
      render :json => {:msg => "user does not have any post"}, :status => 404 and return
    end
    render :json => posts, :only => [:id,:title,:url]
  end

  private
  def post_params
    params.require(:post).permit(:title,:url)
  end

  def set_post
    byebug
    @post = current_user.posts.find_by_id(params["id"].to_i)
    render :json => {:msg => "post does not exist or doesn't belong to the user"}, :status => 404 if @post.blank?
  end
end