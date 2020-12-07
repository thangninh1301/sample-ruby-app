class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index following followers]
  # before_action :correct_user, only: %i[edit update]
  # before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    # redirect_to root_url and return unless @user.activated?
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.where.not(confirmed_at: nil).paginate(page: params[:page])
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'

    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:id)
  end

  # def logged_in_user
  #   unless logged_in?
  #     store_location
  #     flash[:danger] = "Please log in."
  #     redirect_to login_url
  #   end
  # end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # def admin_user
  #   redirect_to(root_url) unless current_user.admin?
  # end
end
