# Post Controller Class
#
# Manage posts
class PostsController < ApplicationController

  def index
    @venue = Venue.find(params[:id])
    @post = @venue.posts.last
  end

end
