# Stephanie Hippo
# slh74@case.edu
# MazeCell creates new MazeCells and allows passages to be formed between cells.
require './lib/UninitializedObjectError.rb'
require './lib/Fixnum.rb'
class MazeCell
  class Status
    attr_accessor :status

    @@code = {:OK => 'OK', :ALREADY_VALID => 'Already Valid', :INVALID_TIME => "Invalid Time", :INVALID_HASH => "Hash Invalid"}

    def initialize
      @status = :OK
    end

    def get_message()
       @@code[self.status]
    end
  end

  attr_reader :id, :valid, :MAX_VALUE
  @@id = 1
  @@MAX_VALUE = Fixnum.max_value

  def initialize
    @passages = Hash.new
    @@id = @@id + 1
    @id = @@id
    @valid = false
    @error = UninitializedObjectError.new
  end

  #returns unique hashCode for this cell
  def hashCode
    @id
  end

  #adds passages to other cells
  def add_passages(passages, status)
    status.status = check_validity_status(status)
    status.status = check_valid_hash_status(passages, status)
    status.status = check_travel_time_status(passages, status)

    if status.status == :OK
      @passages = passages
      @valid = true
    end

    status
  end

  #returns passages that have travel times of less than MAX_VALUE
  def passages
    @error.check_initialized(self)
    temp = @passages.dup
    temp.keep_if{|cell, time| time < @@MAX_VALUE}
  end

  #gives the time to cross
  def passage_time_to(cell)
    @error.check_initialized(self)
    (@passages.has_key? cell) ? @passages[cell] : @@MAX_VALUE
  end

  #returns a set of MazeCells this cell is directly connected to
  def connected_cells()
    passages.keys
  end

  #returns whether this cell is a dead end
  def is_dead_end?
    @error.check_initialized(self)
    connected_cells.empty?
  end

  #returns human readable code for this cell
  def to_s
    @valid ? "Cell No. #{@id.to_s}." : "MazeCell not valid"
  end

  private

  #validates Hash is of the correct type and format
  def check_validity_status(status)
    if @valid
      status.status = :ALREADY_VALID
    else
      status.status = :OK
    end
  end

  def check_valid_hash_status(passageshash, status)
    passageshash.each do |cell, time|
      unless ((cell.class == MazeCell) && (time.is_a? Integer))
        status.status = :INVALID_HASH
      end
    end
    status.status
  end

  def check_travel_time_status(passages, status)
    if status.status == :INVALID_HASH
      return status.status
    end

    passages.values.each do |v|
      status.status = :INVALID_TIME if (v < 0 || @@MAX_VALUE < v)
    end
    status.status
  end
end