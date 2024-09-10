require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:supplier).optional }

  it { is_expected.to validate_presence_of(:customer_name) }
end
