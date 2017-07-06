class Note < ApplicationRecord
  validates :title, :content, presence: true
  has_many :tags
end
