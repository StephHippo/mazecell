# Stephanie Hippo
# MazeRoute assembles a path of valid MazeCells and calculates their travel time.
# MazeRoute uses the Cell Manager module to help add cells to the route
require './UninitializedObjectError.rb'
require './Requires_Valid_Collection.rb'

class MazeRoute
  include Requires_Valid_Collection
  attr_accessor :valid

  def initialize
    @cellpath = []
    @valid = false
    @error = UninitializedObjectError.new
  end

  #adds the given list of cells to the route and makes it valid
  def add_cells(routeCells)
    add_members_to_collection(routeCells) {|routeCells| @cellpath = routeCells }
  end

  #Returns all cells in the route
  def get_cells
    @error.check_initialized(self)
    @cellpath
  end

  #Returns a human-readable string for the route
  def to_s
    @error.check_initialized(self)
    str = ''
    @cellpath.each_cons(2) {|cell, nextcell| str << buildString(cell, nextcell)}
    str << "Total travel time is: #{travel_time}."
  end

  #calculates the total travel time of the route
  def travel_time
    @error.check_initialized(self)
    total_time{|cell, nextcell| get_travel_time(cell, nextcell)}
  end

  #calculates a random travel time at each passage, not exceeding the set passage time
  def travel_time_random()
    @error.check_initialized(self)
    total_time{|cell, nextcell| get_random_travel_time(cell, nextcell)}
  end

  private
  def total_time()
    time = 0
    @cellpath.each_cons(2) do |cell, nextcell|
      if cell.passages.has_key? nextcell
        time += yield cell, nextcell
      else
        time = cell.MAX_VALUE
      end
    end
    time
  end

  def get_travel_time(cell, nextcell)
    cell.passages[nextcell]
  end

  def get_random_travel_time(cell, nextcell)
    random = Random.new
    random.rand(1..get_travel_time(cell,nextcell))
  end

  def addTime(cell, nextcell)
    if cell.passages.has_key? nextcell
      time += yield cell, nextcell
    else
      time = cell.MAX_VALUE
    end
  end

  def buildString(cell, nextcell)
    if cell.passages.include? nextcell
      "Travel from #{cell.to_s} to #{nextcell.to_s} in #{cell.passage_time_to(nextcell)} seconds. \n "
    else
      "No such passage from #{cell.to_s} to #{nextcell.to_s}."
    end
  end
end
