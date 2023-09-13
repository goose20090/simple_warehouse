require 'commands/command'

class Locate < Command
  COMMAND = 'locate'
  ARGS = 'P'
  HELP = 'Show a list of all locations occupied by product code P.'

  def execute(args)
    product_code = args.first
    warehouse.locate(product_code)
  end
end
