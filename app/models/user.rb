# User Class
#
# User active record model
class User < ActiveRecord::Base

  # Associations
  has_many :posts

end
