class UsersController < ApplicationController
	before_action :authenticate_user!, :except => [:show_user_profile, :followers; :following]

	def my_current_user
		render json: my_current_user
	end

	def random_users
		@user = User.where.not(id: current_user.id) -current_user.all_following
		render json: @users.sample(5)
	end

	def show_current_user_profile
		@user = User.find(params[:id])
		render json: @user
	end

	def show_user_profile
		@user = User.find_by(username: params[:username])
		render json: @user
	end

	def follow
		user = User.find(params[:user_id])
		@follow = current_user.follow(user)
		render json: @follow
	end

	def unfollow
		user = User.find(params[:user_id])
		@unfollow = current_user.stop_following(user)
		render json: @unfollow
	end

	def followers
		@users = User.find(params[:id]).followers
		render json: @users
	end

	def following
		@users = User.find(params[:id]).all_following
		render json: @users
	end

	def is_following
		@user = User.find(params[:user_id]).followed_by?(current_user)
		render json: @user
	end

	def update_user
		@user = User.find(params[:id])
		if @user.update(user_params)
			head :no_content
		else
			render json: @user.errors, status: :unprocessable_entity
		end
	end

private

	def user_params
		params.require(:user).permit(:username, :avatar, :password)
	end

end