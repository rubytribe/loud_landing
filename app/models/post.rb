# Post Class
#
# Post active record model
class Post < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :venue
  belongs_to :emotion

end
