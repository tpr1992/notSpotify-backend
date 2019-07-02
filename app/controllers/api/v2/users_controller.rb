class Api::V2::UsersController < ApplicationController

  # def set_user
  #
  # end

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new(params)
    @user.save
    render json: @user
  end
end
