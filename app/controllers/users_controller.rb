class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index following followers edit]
  load_and_authorize_resource

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      if user_params[:email] != @user.email
        flash[:success] = "'Profile updated', an email had send to #{user_params[:email]}"
      end
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  def index
    @users = User.where.not(confirmed_at: nil).paginate(page: params[:page])
  end

  def following
    @title = 'Following'
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
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
