require 'rails_helper'

RSpec.describe FulfillOrdersJob, type: :job do
  describe '#perform' do
    subject { job.perform }


    let(:job) { described_class.new }

    let!(:order_one) { Order.create(customer_name: 'Lionel Messi', product: Product.create( name: 'Golden Boot')) }
    let!(:order_two) { Order.create(customer_name: 'Cristiano Ronaldo', product: Product.create(name: 'Balon d Or')) }
    let!(:order_three) { Order.create(customer_name: 'Kylian Mbappe', product: Product.create(name: 'Turtle Ninja Figurine')) }

    context 'when there are no suppliers' do
      it 'does not change any orders' do
        expect { subject }.not_to(change { Order.all.map(&:attributes) })
      end
    end

    context 'when there are some suppliers' do
      let!(:supplier_foo) { Supplier.create(name: 'supplier_foo') }
      let!(:supplier_bar) { Supplier.create(name: 'supplier_bar') }

      context 'but none of them have stock for the orders' do
        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(0)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(0)
        end

        it 'does not change any orders' do
          expect { subject }.not_to(change { Order.all.map(&:attributes) })
        end
      end

      context 'and not all orders can be fulfilled by a supplier' do
        let(:supplier_foo_reference) { SecureRandom.uuid }
        let(:supplier_bar_reference) { SecureRandom.uuid }

        before do
          allow(SupplierFooApi::Client).to receive(:stock).and_return(3, 0, 0)
          allow(SupplierBarApi::Client).to receive(:stock).and_return(7, 0)
          allow(SupplierFooApi::Client).to receive(:fulfill).and_return(supplier_foo_reference)
          allow(SupplierBarApi::Client).to receive(:fulfill).and_return(supplier_bar_reference)
        end

        it 'updates all orders with the supplier and the supplier reference' do
          expect { subject }.to change { Order.all.pluck(:supplier_id, :supplier_reference, :state) }
            .from([[nil, nil, 'pending'], [nil, nil, 'pending'], [nil, nil, 'pending']])
            .to([[supplier_foo.id, supplier_foo_reference, 'completed'], [supplier_bar.id, supplier_bar_reference, 'completed'], [nil, nil, 'pending']])
        end

        it 'completes the correct number of orders' do
          expect { subject }.to change { Order.where(state: 'completed').count }.by(2)
          expect(Order.count).to eq(3)

          expect(order_one.updated_at.round).to eq(Time.current.round)
          expect(order_three.updated_at.round).to eq(Time.current.round)
        end
      end
    end
  end
end