FactoryBot.define do
  factory :order do
    product
    customer_name { 'Customer Name' }
    supplier_reference { SecureRandom.uuid }
    pending { Order.states[:pending] }
    completed { Order.states[:completed] }
  end
end