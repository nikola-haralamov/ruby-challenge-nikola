class Order < ApplicationRecord

  include HasState

  belongs_to :product
  belongs_to :supplier, optional: true

  validates :customer_name, presence: true
end
