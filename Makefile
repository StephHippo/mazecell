all:
	ruby -c Maze_Cell.rb
	ruby -c Maze_Route.rb
	ruby -c UninitializedObjectError.rb
	ruby -c Maze.rb
	ruby -c Fixnum.rb

test:
	rspec spec

rdoc:
	rm -r doc
	rdoc