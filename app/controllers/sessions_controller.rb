class SessionsController < ApplicationController

  before_action :already_logged_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user
      login!(@user)
      redirect_to cats_url
    else
      @user = User.new(user_name: params[:user][:user_name])
      flash.now[:errors] = ["Invalid User/Password combination"]
      render :new
    end
  end

  def destroy
    logout!
    redirect_to cats_url
  end




end
