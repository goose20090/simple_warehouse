require 'commands/command'

class View < Command
  COMMAND = 'view'
  ARGS = ''
  HELP = "Output a visualisation of the warehouse, its current items and their location"


  def execute _args
    warehouse.layout.reverse.map(&:join).join("\n") # reversed to make 0,0 appear at bottom left
  end
end
