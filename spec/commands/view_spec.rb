require 'spec_helper'
require 'commands/view'

describe View do
  describe '.command' do
    subject { described_class.command }
    it { is_expected.to eq 'view' }
  end

  describe '#execute' do
    let(:warehouse) { Warehouse.new }

    it 'shows an empty warehouse' do
      warehouse.init(3, 2)
      view = described_class.new(warehouse)
      expect(view.execute([])).to eq("...\n...")
    end
  end
end
