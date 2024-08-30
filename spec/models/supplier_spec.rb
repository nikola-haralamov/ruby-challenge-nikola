require 'rails_helper'

RSpec.describe Supplier, type: :model do
  subject { described_class.create(name: 'supplier_foo') }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it { is_expected.to have_many(:orders) }
end
