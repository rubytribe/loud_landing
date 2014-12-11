# Post Controller Class
#
# Manage posts
class PostsController < ApplicationController

  def index
    @venue = Venue.find(params[:id])
    @posts = @venue.posts.where(is_loud: true)
  end

end
