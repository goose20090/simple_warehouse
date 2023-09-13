class Crate
  attr_reader :location_x, :location_y, :width, :height, :product_code

  def initialize location_x, location_y, width, height, product_code
    @location_x = location_x
    @location_y = location_y
    @width = width
    @height = height
    @product_code = product_code
  end

end
