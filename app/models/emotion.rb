# Emotion Class
#
# Emotion active record model
class Emotion < ActiveRecord::Base

  # Associations
  has_many :posts

end
