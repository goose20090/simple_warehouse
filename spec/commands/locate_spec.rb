require 'spec_helper'
require 'commands/locate'

describe Locate do

  let(:warehouse) { Warehouse.new }
  let(:locate) { Locate.new(warehouse) }

  def locate_product(product_code)
    locate.execute([product_code])
  end

  describe '.command' do
    subject { described_class.command }
    it { is_expected.to eq 'locate' }
  end

  describe '#execute' do
    before do
      warehouse.init(5, 5)
    end

    describe 'locating a product that is stored' do
      before do
        warehouse.store(Crate.new(2, 2, 2, 2, 'A'))
      end

      it 'returns the locations of the product' do
        response = locate_product('A')
        expect(response).to include('(2,2)', '(2,3)', '(3,2)', '(3,3)')
      end
    end

    describe 'locating a product that is not stored' do
      it 'returns a message indicating the product is not found' do
        response = locate_product('B')
        expect(response).to eq("Product code B not found in the warehouse.")
      end
    end

    describe 'locating a product that is stored in multiple crates' do
      before do
        warehouse.store(Crate.new(0, 0, 2, 2, 'C'))
        warehouse.store(Crate.new(3, 3, 2, 2, 'C'))
      end

      it 'returns all the locations of the product' do
        response = locate_product('C')
        expect(response).to include('(0,0)', '(0,1)', '(1,0)', '(1,1)', '(3,3)', '(3,4)', '(4,3)', '(4,4)')
      end
    end
  end
end
