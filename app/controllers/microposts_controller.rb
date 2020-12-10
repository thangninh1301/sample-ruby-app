class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy all_reaction show]
  load_and_authorize_resource

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  def show
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end
  end

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end
end
