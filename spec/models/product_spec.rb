require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { described_class.create(name: 'Test product name') }

  it { is_expected.to have_many(:orders) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
