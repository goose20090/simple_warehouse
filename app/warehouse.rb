class Warehouse

  attr_reader :layout

  def initialize
    @width = 0
    @height = 0
    @layout = []
  end


  def init(width, height)
    @width = width
    @height = height
    @layout = Array.new(height) {Array.new(width, '.')}
  end
end
