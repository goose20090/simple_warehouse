require 'spec_helper'
require 'commands/init'

describe Init do

  let(:warehouse) {Warehouse.new}
  let(:init) {Init.new(warehouse)}

  def initialize_with dimensions
    init.execute(dimensions)
  end

  describe '.command' do
    subject { described_class.command }
    it { is_expected.to eq 'init' }
  end

  describe '#execute' do
    it 'initialises the warehouse with given dimensions' do
      expect(initialize_with([3, 2])).to eq("Warehouse initialised with dimensions 3x2")
      expect(warehouse.layout).to eq([['.', '.', '.'], ['.', '.', '.']])
    end

    it 'reinitialises the warehouse with new dimensions' do
      initialize_with([3,2])

      expect(init.execute([2, 3])).to eq("Warehouse initialised with dimensions 2x3")
      expect(warehouse.layout).to eq([['.', '.'], ['.', '.'], ['.', '.']])
    end

  end
end
