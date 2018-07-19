class User < ApplicationRecord
  before_save { self.name = name.downcase }

  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false }


  def update_last_login
    update_attribute(:last_login, Time.now)
  end

end
