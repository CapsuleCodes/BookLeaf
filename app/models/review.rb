class Review < ActiveRecord::Base
    belongs_to :user
    validates :title, :image_url, :description, presence: true
end