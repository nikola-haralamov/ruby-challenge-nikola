class Order < ApplicationRecord
  belongs_to :product
  belongs_to :supplier, optional: true

  validates :customer_name, presence: true

  scope :pending, -> { where(state: 'pending') }
  # scope :completed, -> { where(state: 'completed') }
end
