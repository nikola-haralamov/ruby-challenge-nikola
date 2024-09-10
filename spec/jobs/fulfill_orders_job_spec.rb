require 'rails_helper'

RSpec.describe FulfillOrdersJob, type: :job do

  subject { described_class.new }

  let!(:order) do
    Order.create(
      customer_name: "Customer Name",
      product: Product.create(name: "Product Name"),
      state: Order.states[:pending]
    )
  end

  describe '#perform' do

    context 'when there are no suppliers' do
      it 'does not change order' do
        expect { subject.perform }.not_to(change { order.attributes })
      end
    end

    context 'when there are some suppliers' do
      let!(:supplier) { Supplier.create(name: 'supplier_foo') }

      context 'but none of them have stock for the order' do
        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(0)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(0)
        end

        it 'does not change order' do
          expect { subject.perform }.not_to(change { order.attributes })
        end
      end

      context 'and order can be fulfilled by a supplier' do
        let(:supplier_reference) { SecureRandom.uuid }

        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(3)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(7)
          allow(SupplierFooApi::Client).to receive(:fulfill).and_return(supplier_reference)
          allow(SupplierBarApi::Client).to receive(:fulfill).and_return(supplier_reference)
        end

        it 'updates order with the supplier and the supplier reference' do
          expect { subject.perform }.to change {
            Order.all.pluck(:supplier_id, :supplier_reference, :state)
          }.from([[nil, nil, 'pending']]).to([[supplier.id, supplier_reference, 'completed']])
        end
      end

    end
  end
end