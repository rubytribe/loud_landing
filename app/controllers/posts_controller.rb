# Post Controller Class
#
# Manage posts
class PostsController < ApplicationController

  def index
    @venue = Venue.find(params[:id])
    @posts = @venue.posts.order('created_at')
    
    if params[:requested] == 'new-posts'
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
