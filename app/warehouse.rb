class Warehouse

  attr_reader :layout
  attr_writer :current_stock

  def initialize
    @width = 0
    @height = 0
    @layout = []
    @current_stock = []
  end


  def init(width, height)
    @width = width
    @height = height
    @layout = Array.new(height) {Array.new(width, '.')}
  end

  def store(crate)
    placement = {
      start_y: crate.location_y,
      end_y: crate.location_y + crate.height - 1, # minus 1 to account for 0 indexing
      start_x: crate.location_x,
      end_x: crate.location_x + crate.width - 1
    }

    return false unless valid_placement?(placement)

    (placement[:start_y]..placement[:end_y]).each do |y|
      (placement[:start_x]..placement[:end_x]).each do |x|
        @layout[y][x] = crate.product_code
      end
    end

    @current_stock << crate

    true
  end

  def locate product_code

    crates = find_crates(product_code)

    return "Product code #{product_code} not found in the warehouse." if crates.empty?

    all_coordinates = crates.flat_map { |crate| generate_coordinates(crate) }
    final_str = all_coordinates.map { |x, y| "(#{x},#{y})" }.join(", ")
  end

  private

  def find_crates(product_code)
    @current_stock.select{|crate| crate.product_code == product_code}
  end

  def generate_coordinates(crate)
    coordinates = []
    (crate.location_y...crate.location_y + crate.height).each do |y|
      (crate.location_x...crate.location_x + crate.width).each do |x|
        coordinates << [x, y]
      end
    end
    coordinates
  end

  def valid_placement?(placement)
    # Check if it goes outside of warehouse
    return false if placement[:end_x] > @layout.first.length
    return false if placement[:end_y] > @layout.length

    # Checks for existing crates in these coordinates
    (placement[:start_y]..placement[:end_y]).each do |y|
      (placement[:start_x]..placement[:end_x]).each do |x|
        return false unless @layout[y][x] == '.'
      end
    end
    true
  end
end
