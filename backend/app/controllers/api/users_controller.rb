module Api
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      skip_before_action :verify_authenticity_token, only: [:create]
  
      def index
        @users = User.all
        render json: @users
      end
  
      def show
        render json: @user
      end
  
      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
  
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
  
      def destroy
        @user.destroy
        head :no_content
      end
  
      private
  
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:name, :email, :password) # パスワードの受け取りを許可
      end
    end
end
  
