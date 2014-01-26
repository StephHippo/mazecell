require './Maze_Cell.rb'

describe MazeCell do

  before :each do
    @cell = MazeCell.new
    @a = MazeCell.new
    @b = MazeCell.new
  end

  describe "new" do
    it "takes no parameters and returns a MazeCell object" do
      @cell.should be_an_instance_of MazeCell
      @cell.valid.should be false
    end
  end

  describe "addPassages" do
    it "adds passages to the cell if the cell was previously unconnected and makes it valid" do
      status = MazeCell::Status.new
      @cell.add_passages({@a => 1, @b => 2}, status)
      @cell.valid.should be_true
    end

    it "allows the creation of a dead end by passing an empty hash" do
      @cell = MazeCell.new
      status = MazeCell::Status.new
      @cell.add_passages({}, status)
      @cell.valid.should be_true
    end

    it "leaves the cell invalid if passed an invalid hash" do
      status = MazeCell::Status.new
      @cell.add_passages({2 => @cell},status)
      @cell.valid.should be false
    end
  end

  describe "passages" do
    it "returns the passages from this Maze whose travel time is less than MAX_VALUE" do
      status = MazeCell::Status.new
      @cell.add_passages({@a => 1}, status)
      @cell.passages.should be_eql({@a => 1})
    end
  end

  describe "passageTimeTo" do
    it "gives the times to cross from this cell to the given cell" do
      status = MazeCell::Status.new
      @a.add_passages({@b => 1}, status)
      @a.passage_time_to(@b).should be 1
    end

    it "returns MAX_VALUE of Fixnum if there is no direct passage" do
      status = MazeCell::Status.new
      @b.add_passages({@a => 2}, status)
      @b.passage_time_to(@cell).should be Fixnum.max_value
    end
  end

  describe "connectedCells" do
    it "returns a set of cells to which this cell is directly connected with a travel time less than MAX_VALUE" do
      #@cell.addPassages({@a => 3, @b => (Fixnum.max_value + 1)})
      status = MazeCell::Status.new
      @cell.add_passages({@a => 3}, status)
      @cell.connected_cells.should match_array [@a]
    end
  end

  describe "isDeadEnd" do
    it "returns true if this cell has no outgoing passages" do
      status = MazeCell::Status.new
      @cell.add_passages({}, status)
      @cell.is_dead_end?.should be true
    end

    it "returns false if this cell has outgoing passages" do
      status = MazeCell::Status.new
      @cell.add_passages({@b => 3}, status)
      @cell.is_dead_end?.should be false
    end
  end

  describe "to_s" do
    it "returns a human readable code for the cell" do
      @cell.to_s.should eql "MazeCell not valid"
    end

    it "returns a human readable code for the cell" do
      status = MazeCell::Status.new
      @mycell = MazeCell.new
      @mycell.add_passages({@a => 3, @b => 1}, status)
      @mycell.to_s.should eql "Cell No. #{@mycell.id.to_s}."
    end

  end
end