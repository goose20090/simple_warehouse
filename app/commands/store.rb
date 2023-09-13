require 'commands/command'
require_relative '../crate'

class Store < Command
  COMMAND = 'store'
  ARGS = 'X Y W H P'
  HELP = 'Stores a crate of product code P and of size W x H at position (X,Y). The crate will occupy W x H locations on the grid.'

  def execute(args)
    x, y, width, height, product_code = args
    x, y, width, height = [x, y, width, height].map(&:to_i)

    crate = Crate.new(x, y, width, height, product_code)

    if warehouse.store(crate)
      "Stored crate of product code #{product_code} of dimensions #{width}x#{height} at position (#{x},#{y})"
    else
      "Not enough space to put this crate here"
    end
  end
end
