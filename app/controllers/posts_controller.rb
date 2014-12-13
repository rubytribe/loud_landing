# Post Controller Class
#
# Manage posts
class PostsController < ApplicationController

  def index
    @venue = Venue.find(params[:id])
    @posts = @venue.posts.where(is_loud: true).order('created_at')
    
    if request.xhr?     
      @posts = @posts.where('created_at > ?', params[:last_post])
      if @posts.any?
        render partial: 'posts/partials/posts'
      else
        render text: 'no new posts'
      end
    else
      render 'index'
    end
    
  end

end
