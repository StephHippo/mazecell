#Stephanie Hippo
#slh74@case.edu
#Manage Cells allows Maze and MazeRoute to use the same structure for adding cells
require './UninitializedObjectError.rb'

module Requires_Valid_Collection

  def add_members_to_collection(collection)
    unless self.valid
      if is_valid_collection?(collection)
        yield collection
        self.valid = true
      else
        return false
      end
    else
      return false
    end
    self.valid
  end

  #check that each member in the collection is valid
  def is_valid_collection?(collection)
    error = UninitializedObjectError.new
    collection.each do |col|
      error.check_initialized(col)
    end
    return true
  rescue
    return false
  end
end