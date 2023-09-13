# Simple Warehouse Exercise Notes

This was an exercise that involved getting commands from a command line interface working.

As part of the exercise I'm documenting my process as requested.

## Initial analysis

The most important part of this exercise, for me, was the initial reading and understanding of the codebase I was working with.

I was given a pre-existing CommandLineInterface class, with the `help` and `exit` commands already set up, with specs for each of these as well. There was also a `runner.rb` file that could act as my initialiser

With all these files, I decided pretty quickly to do my best to follow these as a kind of template and guide for how I would build the rest of the commands.

## Init and View

- For the init command, I could see that each the starter file had a `@warehouse` variable inherited by the parent command class

- This variable is defined when command is initialised when the `command_line_interface.rb` file is run

- Therefore, I made an init method in the warehouse class, which I knew the `init.rb` class would have access to and gave some variables of height, width and layout for the warehouse to initialise with

My init method simply defined these variables:

```ruby
# app/warehouse.rb
  def init(width, height)
    @width = width
    @height = height
    @layout = Array.new(height) {Array.new(width, '.')}
  end

```

Which I called in my init command class, using the user deliverables as a template for my success message:

```ruby
# app/commands/init.rb
    warehouse.init(width, height)
    "Warehouse initialised with dimensions #{width}x#{height}"
```

Because this acted essentially as a setter method, the user would be able to reinitialise the warehouse with the same command

For the layout and view methods, I used logic very similar to how I would build a tic-tac-toe game (an exercise I've done whenever I've learned a new language) and used a the height and width variables to construct a 2D array:

```ruby
# app/warehouse.rb
   @layout = Array.new(height) {Array.new(width, '.')}
```

Before reversing and joining each on a new line, making a string printable to the console in my view command's execute method:

```ruby
# app/commands.view.rb
  def execute _args
   warehouse.layout.reverse.map(&:join).join("\n") # reversed to make 0,0 appear at bottom left
 end
```

## Store

### Making a crate class and a store command

At this point I began to think that I needed a crate class to encapsulate the data of a new crate being stored in the warehouse.

I kept it really simple and just had it initalise with the required arguments, while giving it some getter methods:

```ruby
# app/crate.rb
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
```

I then created a new store command class, following the requirements outlined in the brief and using the existing commands as a template. I used the new crate class to encapsulate the data passed to the store class:

```ruby
# app/commands/store.rb
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
  end
end
```

### Making a store method in the warehouse class

I then began to build out a corresponding store method in my warehouse class, that would accept the crate as an argument:

```ruby
# app/warehouse.rb
  def store(crate)
  end
```

In building out this method, I started by creating a placement hash to hold the dimensions of the crate and where they're proposed to be stored in the warehouse (slightly modifying the values to account for my 2D array's zero indexing):

```ruby
# app/warehouse.rb
def store(crate)
	placement = {
      start_y: crate.location_y,
      end_y: crate.location_y + crate.height - 1, # minus 1 to account for 0 indexing
      start_x: crate.location_x,
      end_x: crate.location_x + crate.width - 1
    }
end
```

I then used a nested iteration to convert the necessary cells in my 2D array to the appropriate product code:

```ruby
# app/warehouse.rb
	 (placement[:start_y]..placement[:end_y]).each do |y|
      (placement[:start_x]..placement[:end_x]).each do |x|
        @layout[y][x] = crate.product_code
      end
    end
```

This would achieve the right result when there was a valid crate. My next step was to put in some validations to reject crate placements which would overlap with other crates or exceed the boundaries of the warehouse.

### Validation logic for the store method

I built out a method that could validate a crate's proposed placement:

```ruby
# app/warehouse.rb
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
```

And then used this to make my store method return true on a valid crate and false on an invalid one:

```ruby
# app/warehouse.rb
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

    true
  end

```

I then used the Boolean response of my warehouse class's store method to return the appropriate message my store command class's execute method:

```ruby
# app/commands/store.rb
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
```

## Locate

I started by building out the locate command similar to the others:

```ruby
# app/commands/locate.rb
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

```

I realised at this point that I wanted my warehouse class to keep track of each of the crates it currently had in it.

Therefore, I added a new `current_stock` variable:

```ruby
# app/warehouse.rb
class Warehouse

  attr_reader :layout
  attr_writer :current_stock

  def initialize
    @width = 0
    @height = 0
    @layout = []
    @current_stock = []
  end

  # rest of code
end

```

And updated the warehouse class's `#store` method to add a crate to this new variable, after storing a valid crate:

```ruby
# app/warehouse.rb

    @current_stock << crate
```

I then built out a find_crates method, using the product code:

```ruby
# app/warehouse.rb

  def find_crates(product_code)
    @current_stock.select{|crate| crate.product_code == product_code}
  end
```

And started my Warehouse class's `#locate` method by using this method to check if that product code existed in the warehouse:

```ruby
# app/warehouse.rb

  def locate product_code

    crates = find_crates(product_code)

    return "Product code #{product_code} not found in the warehouse." if crates.empty?

  end
```

I then built out a `#generate_cordinates method` that accepted a crate as an argument and generated a pair of co-ordinates for each cell that crate occupied:

```ruby
# app/warehouse.rb

	def generate_coordinates(crate)
    coordinates = []
    (crate.location_y...crate.location_y + crate.height).each do |y|
      (crate.location_x...crate.location_x + crate.width).each do |x|
        coordinates << [x, y]
      end
    end
    coordinates
  end
```

I then used this method to iterate through the crates that had the appropriate product code and return a list of all co-ordinates. I flattened the return value to eliminate unnecessary nesting and used the join method to return a string, finishing the method:

```ruby
# app/warehouse.rb

  def locate product_code

    crates = find_crates(product_code)

    return "Product code #{product_code} not found in the warehouse." if crates.empty?

    all_coordinates = crates.flat_map { |crate| generate_coordinates(crate) }
    final_str = all_coordinates.map { |x, y| "(#{x},#{y})" }.join(", ")
  end

```

## A note on testing

I continued to use Rspec for the tests and simply tried to follow the examples laid out in the prewritten ones, trying to account for edge cases that arose for each command.

## Thoughts on Design and improvement

I'm overall happy with my solution.

I think it was the right decision to make a crate class- it felt 'right' from an Object Oriented standpoint and I think prevented a lot of repeated code.

The main thought I have about how I would improve this is thinking about where to put the 'placement' hash:

```ruby
# app/warehouse.rb

placement = {
      start_y: crate.location_y,
      end_y: crate.location_y + crate.height - 1, # minus 1 to account for 0 indexing
      start_x: crate.location_x,
      end_x: crate.location_x + crate.width - 1
    }
```

It made sense to me while working on this to have this generated in the warehouse class, ie. the warehouse should be responsible for figuring out where a crate is placed within it.

That being said, I came into a few problems with this being the case. For example, I wasn't particularly happy with the if else statement in my Store class's execute method:

```ruby
# app/commands/store.rb

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
```

I'd prefer to be able to call something like `warehouse.valid_placement?(crate)` as the test for my return statement, and not to have my `#store` method return a Boolean, but having the placement be generated within the the store method means I can only validate it within the store method without regenerating the hash and repeating code in other ways.

I think this could be solved in a few ways: by making the crate responsible for generating its placement hash, or maybe just making a helper method in the warehouse class, but as I'm stopping here I wanted to document this as something I'd like to improve.

## Outro

Thank you for reading and for the challenge- I found it to be stimulating and a lot of fun. I look forward to being able to answer any questions you might have in a future discussion.
