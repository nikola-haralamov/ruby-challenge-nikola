FactoryBot.define do
  factory :order do
    product
    customer_name { 'String' }
    supplier_reference { 'String' }
    pending { Order.states[:pending] }
    completed { Order.states[:completed] }
  end
end