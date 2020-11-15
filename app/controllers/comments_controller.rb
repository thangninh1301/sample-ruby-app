class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    puts params.inspect
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:success] = 'comment created!'
    else
      flash[:error] = 'comment not created!'
    end
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'comment deleted'
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  def comment_params
    params.permit(:content, :image, :micropost_id, :super_comment_id)
  end

  private

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id])
    redirect_to root_url if @comment.nil?
  end
end
