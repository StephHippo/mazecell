require './Maze_Route.rb'
require './Maze_Cell.rb'
require './UninitializedObjectError.rb'

describe MazeRoute do

  before :each do
    @route = MazeRoute.new
    @a = MazeCell.new
    @b = MazeCell.new
    @c = MazeCell.new
    astatus = MazeCell::Status.new
    bstatus = MazeCell::Status.new
    cstatus = MazeCell::Status.new
    @a.add_passages({@b => 4}, astatus)
    @b.add_passages({@c => 4}, bstatus)
    @c.add_passages({}, cstatus)
  end

  describe "new" do
    it "takes no parameters and returns a MazeRoute object" do
      @route.should be_an_instance_of MazeRoute
    end
  end

  describe "addCells" do
    it "adds the given list of cells to the route and makes the route valid" do
      @route.add_cells([@a, @b]).should be true
      @route.valid.should be true
    end

    it "returns false if a cell is invalid" do
      @d = MazeCell.new
      @route.add_cells([@a, @b, @d]).should be false
    end
  end

  describe "get_cells" do
    it "returns the list of cells in the maze" do
      @route.add_cells([@a, @b]).should be true
      @route.get_cells.should match_array [@a, @b]
    end

    it "raises an error if the Route is invalid" do
      @route = MazeRoute.new
      lambda {@route.get_cells}.should raise_error
    end
  end

  describe "to_s" do
    it "returns a human readable representation of this route" do
      @route.add_cells([@a, @b, @c])
      @route.to_s.should eql "Travel from #{@a.to_s} to #{@b.to_s} in #{@a.passage_time_to(@b)} seconds. \n Travel from #{@b.to_s} to #{@c.to_s} in #{@b.passage_time_to(@c)} seconds. \n Total travel time is: 8."
    end
  end

  describe "to_s" do
    it "raises an error if the route is invalid" do
      lambda {@route.add_cells}.should raise_error
    end
  end

  describe "travelTime" do
    it "returns the time needed to follow this route" do
      @route.add_cells([@a, @b, @c])
      @route.travel_time.should be 8
    end

    it "returns 0 if the route consists of only 1 cell" do
      @route = MazeRoute.new
      @route.add_cells([@a])
      @route.travel_time.should be 0
    end

    it "returns an UninitializedObjectError if the route is invalid" do
      @route = MazeRoute.new
      lambda {@route.travel_time}.should raise_error
    end
  end

   describe "travelTimeRandom" do
     it "returns a random time to follow the route if the route is valid" do
       @route.add_cells([@a, @b, @c])
       @route.travel_time_random.should be <= 8
     end

     it "returns an UninitializedObjectError if the route is invalid" do
       @route = MazeRoute.new
       lambda {@route.travel_time_random}.should raise_error
     end
   end
end