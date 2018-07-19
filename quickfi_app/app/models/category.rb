class Category < ApplicationRecord
  belongs_to :user
  #has_many :transactions

  before_save { self.name = name.downcase }

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }

  def self.user_categories(user_id)
    Category.where(user_id: user_id)
  end
end
