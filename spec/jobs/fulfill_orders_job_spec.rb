require 'rails_helper'

RSpec.describe FulfillOrdersJob, type: :job do
  describe '#perform' do
    subject { described_class.new }

    #let!(:order) { create(:order) }

    let!(:order) do
      Order.create(
        customer_name: "Lionel Messi",
        product: Product.create(name: "Golden Boot"),
        state: Order.states[:pending]
      )
    end

    context 'when there are no suppliers' do
      it 'does not change any order' do
        expect { subject.perform }.not_to(change { order.attributes })
      end
    end

    context 'when there are some suppliers' do
      let(:supplier_foo) { Supplier.create(name: 'supplier_foo') }
      let(:supplier_bar) { Supplier.create(name: 'supplier_bar') }

      context 'but none of them have stock for the order' do
        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(0)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(0)
        end

        it 'does not change any order' do
          expect { subject.perform }.not_to(change { order.attributes })
        end
      end

      context 'and orders can be fulfilled by a supplier' do
        let(:supplier_foo_reference) { SecureRandom.uuid }
        let(:supplier_bar_reference) { SecureRandom.uuid }

        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(3)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(7)
          allow(SupplierFooApi::Client).to receive(:fulfill).and_return(supplier_foo_reference)
          allow(SupplierBarApi::Client).to receive(:fulfill).and_return(supplier_bar_reference)
        end

        it 'updates all orders with the supplier foo and the supplier foo reference' do
          expect { subject.perform }.to change {
            Order.all.pluck(:supplier_id, :supplier_reference, :state)
          }.from([[nil, nil, 'pending']]).to([[supplier_foo.id, supplier_foo_reference, 'completed']])
        end

        it 'updates all orders with the supplier bar and the supplier bar reference' do
          expect { subject.perform }.to change {
            Order.all.pluck(:supplier_id, :supplier_reference, :state)
          }.from([[nil, nil, 'pending']]).to([[supplier_bar.id, supplier_bar_reference, 'completed']])
        end

      end

    end
  end
end