# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help; end

  def about; end

  def contact; end
end
