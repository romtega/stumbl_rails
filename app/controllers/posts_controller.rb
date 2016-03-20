class PostsController < ApplicationController
	before_action :authenticate_user!
	before_filter :intercept_html_requests

	def index
		@posts = current_user.followed_users_posts
		render json: @posts
	end

	def create
		@post = current_user.posts.build(post_params)

		if @post.save
			render json: @post, status: :created
		else
			render json: @post.errors, status: :unprocessable_entity
		end 
	end

	def update
		@post = Post.find(params[:id])
		if @post.update(post_params)
			head :no_content
		else
			render json: @post.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@post = Post.find(params[:id])   
		@post.destroy
		render :nothing => true
	end

	def search
    if params[:query]
      @posts = Post.search_posts(params[:query])
    elsif params[:user_id]
      @posts = Post.search_users(params[:user_id])
    end
    render json: @posts
  end


	private

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
  	params.require(:post).permit(:ptype, :title, :content, :psource, :htags, :url, :user_id)
  end

  # if someone asks for html, redirect them to the home page, we only serve json
  def intercept_html_requests
  	redirect_to('/#/dashboard/erro') if request.format == Mime::HTML
  end

end