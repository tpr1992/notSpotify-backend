class UsersController < ApplicationController

  def create
    @user = User.new(params)
    @user.save
    render json: @user
  end
end
