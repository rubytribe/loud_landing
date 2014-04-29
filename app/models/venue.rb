# Venue Class
#
# Venue active record model
class Venue < ActiveRecord::Base

  # Associations
  has_many :posts

end
