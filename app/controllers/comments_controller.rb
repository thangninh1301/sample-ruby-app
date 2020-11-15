class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    @micropost= Micropost.find(@comment.micropost_id)
    if @comment.super_comment_id
      @comment.micropost_id=nil
      @super_comment = Comment.find(@comment.super_comment_id)
    end
    return unless @comment.save
    @passing_comment=@comment
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
    end

  end

  def destroy
    @comment.destroy
    return unless @comment.save
    @passing_comment=@comment
    respond_to do |format|
      format.html { to_last_url }
      format.js {}
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
