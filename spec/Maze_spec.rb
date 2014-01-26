require './Maze.rb'

describe Maze do

  before :each do
    @a = MazeCell.new
    @b = MazeCell.new
    @c = MazeCell.new
    @d = MazeCell.new
    @exit = MazeCell.new
    @f = MazeCell.new
    status = MazeCell::Status.new
    @exit.add_passages({}, status)
    @a.add_passages({@b => 1, @c => 4, @d => 5}, status)
    @b.add_passages({@c => 6, @d =>2}, status)
    @c.add_passages({@exit => 7}, status)
    @d.add_passages({@c => 3}, status)
    @maze = Maze.new
  end

  describe "new" do
    it "takes no parameters and returns a MazeCell object" do
      @maze.should be_an_instance_of Maze
    end
  end

  describe "addCells" do
    it "takes an array of cells, adds them to the maze, and validates the maze" do
      @maze.add_cells([@a, @b, @c, @d, @exit])
      @maze.valid.should be true
    end

    it "returns false if any cell is invalid" do
      @maze = Maze.new
      @maze.add_cells([@a, @b, @f]).should be false
    end
  end

  describe "toString" do
    it "returns a human readable string for this maze" do
      @maze.add_cells([@c, @exit])
      @maze.to_s.should eql "#{@c.to_s} can travel to #{@exit.to_s} in #{@c.passage_time_to(@exit)} seconds. \n"
    end
  end

  describe "routeFirst" do
    it "returns an arbitrary route in the maze" do
      @maze.add_cells([@a, @b, @c, @d, @exit])
      myroute = @maze.route_first(@a)
      myroute.should be_an_instance_of MazeRoute
      myroute.valid.should be true
      myroute.to_s.should eql "Travel from Cell No. 101. to Cell No. 102. in 1 seconds. \n Travel from Cell No. 102. to Cell No. 103. in 6 seconds. \n Travel from Cell No. 103. to Cell No. 105. in 7 seconds. \n Total travel time is: 14."
    end
  end

  describe "routeFirst" do
    it "returns an error if the Maze is invalid" do
      lambda {@maze.route_first(@a)}.should raise_error
    end
  end

  describe "route_random" do
    it "returns a random route in the Maze" do
      @maze.add_cells([@a, @b, @c, @d, @exit])
      myroute = @maze.route_random(@a)
      myroute.should be_an_instance_of MazeRoute
      myroute.valid.should be true
    end
  end

  context "route_random and route_first can return the same route" do
    it "returns the same route when there is only 1 passage to each cell" do
      @cell1 = MazeCell.new
      @cell2 = MazeCell.new
      @cell3 = MazeCell.new

      status = MazeCell::Status.new

      @cell1.add_passages({@cell2 => 3}, status)
      @cell2.add_passages({@cell3 => 4}, status)
      @cell3.add_passages({}, status)

      @maze.add_cells([@cell1, @cell2, @cell3])
      @maze.route_first(@cell1).to_s.should eq @maze.route_random(@cell1).to_s
    end
  end

  describe "route_greedy" do
    it "returns a route within the maze choosing the smallest passage time" do
      @maze.add_cells([@a, @b, @c, @d, @exit])
      route = @maze.route_greedy(@a)
      route.to_s.should eql "Travel from Cell No. 128. to Cell No. 129. in 1 seconds. \n Travel from Cell No. 129. to Cell No. 131. in 2 seconds. \n Travel from Cell No. 131. to Cell No. 130. in 3 seconds. \n Travel from Cell No. 130. to Cell No. 132. in 7 seconds. \n Total travel time is: 13."
    end
  end

  describe "averageExitTime" do
    it "returns the average exit time for a maze" do
      @maze.add_cells([@a, @b, @c, @d, @exit])
      avg = @maze.average_exit_time(@exit) { |cell, exit| @maze.route_first(cell, exit)}
      avg.should eql 11.0
    end
	end
end
