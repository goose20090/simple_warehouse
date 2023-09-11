require 'spec_helper'
require 'warehouse'

describe Warehouse do
  let(:unit) { Warehouse.new }

  describe '#init' do
    it 'initialises the warehouse with the given width and height' do
      unit.init(5,5)
      expect(unit.layout.length).to eq(5)
      expect(unit.layout[0].length).to eq(5)
    end
  end
end
