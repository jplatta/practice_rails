class Word < ApplicationRecord
  validates :word, presence: true
  validates :definition, presence: true
end
