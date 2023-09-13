require 'spec_helper'
require 'commands/store'

describe Store do

  let(:warehouse) { Warehouse.new }
  let(:store) { Store.new(warehouse) }

  def store_crate(args)
    store.execute(args)
  end

  describe '.command' do
    subject { described_class.command }
    it { is_expected.to eq 'store' }
  end

  describe '#execute' do
    before do
      warehouse.init(5, 5)
    end

    describe 'storing a valid crate' do
      it 'stores the crate and returns a success message' do
        response = store_crate([2, 2, 2, 2, 'A'])
        expect(response).to eq("Stored crate of product code A of dimensions 2x2 at position (2,2)")
        expect(warehouse.layout[2][2]).to eq('A')
        expect(warehouse.layout[3][3]).to eq('A')
      end
    end

    describe 'trying to store a crate in an occupied position' do
      before do
        store_crate([2, 2, 2, 2, 'A'])
      end

      it 'returns an error message' do
        response = store_crate([2, 2, 2, 2, 'B'])
        expect(response).to eq("Not enough space to put this crate here")
      end
    end

    describe 'referencing a position outside the warehouse' do
      it 'returns an error message' do
        response = store_crate([6, 6, 2, 2, 'C'])
        expect(response).to eq("Not enough space to put this crate here")
      end
    end
  end
end
