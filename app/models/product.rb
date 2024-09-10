class Product < ApplicationRecord
  has_many :orders

  validates :name, presence: true, uniqueness: true
end
