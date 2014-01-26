# Stephanie Hippo
# Allows a user to create a Maze and traverse different kinds of routes.

require './lib/UninitializedObjectError.rb'
require './lib/Maze_Route.rb'
require './lib/Maze_Cell.rb'
require './lib/Requires_Valid_Collection.rb'
require './lib/Fixnum.rb'
class Maze
  include Requires_Valid_Collection
  attr_accessor :valid

  def initialize()
    @cells = []
    @valid = false
    @error = UninitializedObjectError.new
  end

  #adds the given list of cells to the maze and makes it valid
  def add_cells(cells)
    add_members_to_collection(cells) {|collection| @cells = collection }
  end

  #returns a human readable representation of this maze
  def to_s()
    str = ''
    if @valid
      @cells.each {|cell| str << build_string(cell)}
      str
    else
      "Uninitialized Maze"
    end
  end

  #arbitrarily takes the first passage each time
  def route_first(initialCell, exitCell = nil)
    route = route(initialCell, exitCell) { |arg| first_passage(arg) }
    route
  end

  #takes a random passage each time
  def route_random(initialCell, exitCell = nil)
    random = Random.new
    route = route(initialCell, exitCell) { |arg| random_passage(arg)}
    route
  end

  #takes lowest passage each time
  def route_greedy(initialCell, exitCell = nil)
    route = route(initialCell, exitCell) {|arg| greedy_passage(arg)}
    route
  end

  #finds average travel time for a route
  def average_exit_time(exitCell)
    error = UninitializedObjectError.new
    error.check_initialized(self)
    sum = 0.0
    average = 0.0
    if @cells.include? exitCell
      cells = @cells - [exitCell]

      cells.each do |cell|
        route = yield cell, exitCell
        time_traveled = route.travel_time
        sum = add_to_sum(time_traveled, sum)
      end

      average = sum / cells.length
    else
      return Fixnum.max_value
    end
    average
  end

  def add_to_sum(time_traveled, sum)
    return Fixnum.max_value if time_traveled >= Fixnum.max_value || sum >= Fixnum.max_value
    sum + time_traveled
  end

 private

  def greedy_passage(cell)
    passages = cell.passages
    minpassage = passages.values.min
    temp = passages.select{|key, value| passages[key] == minpassage}
    temp.keys.first
  end

  def first_passage(cell)
    cell.connected_cells[0]
  end

  def random_passage(cell)
    cell.connected_cells.sample
  end

  def build_string(cell)
    str = ''
    neighbors = cell.connected_cells
    neighbors.each do |neighbor|
      str << "#{cell.to_s} can travel to #{neighbor.to_s} in #{cell.passage_time_to(neighbor)} seconds. \n"
    end
    str
  end

  def route(initialCell, exitcell = nil)
    @error.check_initialized(self)

    cell = initialCell
    routeCells = []

    while true
      routeCells = add_maze_cell_to_route_cells(cell, routeCells)
      cell = yield cell
      break unless can_continue(cell, routeCells, exitcell)
    end

    routeCells = add_maze_cell_to_route_cells(cell, routeCells)

    route = MazeRoute.new
    route.add_cells(routeCells)
    route
  end

  #adds the cell to the routeCells if it is in the maze
  def add_maze_cell_to_route_cells(cell, routeCells)
    (@cells.include? cell) ? routeCells << cell : []
  end

  #do not continue if the cell is a dead end, has been visited before, or the cell is not in the maze
  def can_continue(cell, routeCells, exitcell= nil)
    deadEnd = cell.is_dead_end?
    looping = routeCells.include? cell
    exitcell.nil? ? reachedexit = exitcell == cell : reachedexit = false
    !looping && !deadEnd && !routeCells.empty? && !reachedexit
  end
end