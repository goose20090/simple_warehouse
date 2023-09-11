require 'commands/command'

class Init < Command
  COMMAND = 'init'
  ARGS = 'W H'
  HELP = 'Initialises the application as an empty W x H warehouse.'

  def execute(args)
    width, height = args.map(&:to_i)
    warehouse.init(width, height)
    "Warehouse initialised with dimensions #{width}x#{height}"
  end
end
