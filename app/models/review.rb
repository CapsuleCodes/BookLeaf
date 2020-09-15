class Review < ActiveRecord::Base
    belongs_to :user
    validates :title, :image_url, :description, presence: true, uniqueness: true


end