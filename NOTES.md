PROCESS

### Initial thoughts and impressions

I first spent some time with the code- figuring out how it was in operation. Much of the logic and test coverage for the command line interface was already present.

With this in mind, I thought I could move straight on to the commands, using the pre-written exit, help, init and view commands as templates, whilst making sure I was leaving the logic of actually handling and updating the warehouse to the warehouse class.

I thought the deliverables were laid out in a way that it made sense to go through them in order (ie. I wouldn't be able to work on the store command without setting up the init command first )

### Deliverable 1- Warehouse manager can initialise and visualise a warehouse

- 2 commands were specified here: init and view. It made sense to start with init.

- I modified the warehouse class to initialise with 3 instance variables: width (as 0), height (as 0) and layout (as an empty array).

- I then wrote a separate init method to accept the width and height as arguments, assign them to their respective instance variables and build a two dimensional array with height and width based on their values. Empty 'shelves' would be represented with a '.'

- Much of the logic I used for the layout variable was reused from various Tic-Tac-Toe games I'd coded in labs over the past- I noticed the parallel between the two ideas so thought that reviewing the logic there would help me out.

- This also really helped me in the view command- it gave me certain tricks like reversing my layout 2D array to make sure my co-ordinates were accurate for my coming store, locate and remove commands

- It was at this point that I wrote unit tests for the view and init commands, it didn't make sense to write them before I had a clear idea of how I was going to represent a warehouse

- I wrote specs following similar patterns in the pre-existing tests

### Deliverable 2- Warehouse manager can store crates of product in the warehouse

### Ideas for improvement

Making the init command more robust. It currently only accepts 2 numbers as arguments with a whitespace between, it would be good if it could handle other formats e.g. init(3,2) init[3,2] init 3, 2
