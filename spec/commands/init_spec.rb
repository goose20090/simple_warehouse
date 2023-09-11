require 'spec_helper'
require 'commands/init'

describe Init do

  let(:warehouse) {Warehouse.new}
  describe '.command' do
    subject { described_class.command }
    it { is_expected.to eq 'init' }
  end

  describe '#execute' do
    it 'initializes the warehouse with given dimensions' do
      init = described_class.new(warehouse)
      expect(init.execute([3, 2])).to eq("Warehouse initialised with dimensions 3x2")
      expect(warehouse.layout).to eq([['.', '.', '.'], ['.', '.', '.']])
    end
  end
end
