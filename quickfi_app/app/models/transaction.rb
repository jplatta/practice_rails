class Transaction < ApplicationRecord
  belongs_to :user
  before_save :default_credit

  #validates :user_id, presence: true
  validates :amount, presence: true
  validates :description, presence: true, length: {maximum: 255}
  validates :category_id, presence: true

  scope :month, -> (user_id,month,year) { where("user_id = ? and extract(month from date) = ? and extract(year from date) = ?", user_id, month, year)}
  scope :month_category_totals, -> (user_id,month,year) { where("user_id = ? and extract(month from date) = ? and extract(year from date) = ?", user_id, month, year)
                                                          .group("category_id")
                                                          .sum("amount")}

  def default_credit
    if self.credit.nil?
      self.credit = false
    end
  end

  def set_current_user
    self.user_id = current_user
  end

end
