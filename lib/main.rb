# frozen_string_literal: true

class Vertex
  attr_reader :vertex
  attr_accessor :neighbors

  def initialize(vertex)
    @vertex = vertex
    @neighbors = []
  end
end

class Board
  attr_reader :board

  def initialize
    @board = create_board
  end

  private

  def create_board(vertex = [0, 0], cells = [])
    return create_board([vertex[0] + 1, 0], cells) if vertex[1] > 7

    return if vertex[0] > 7

    new_cell = Vertex.new(vertex)
    cells.each do |cell|
      next unless neighbor?(vertex, cell)

      new_cell.neighbors << cell
      cell.neighbors << new_cell
    end
    cells << new_cell
    create_board([vertex[0], vertex[1] + 1], cells)
    cells
  end

  def neighbor?(new_cell, cell)
    column = (new_cell[0] - cell.vertex[0]).abs
    row = (new_cell[1] - cell.vertex[1]).abs
    true if (column == 2 && row == 1) || (column == 1 && row == 2)
  end
end

class Knight < Board
  def initialize
    super
  end

  def knight_moves(start, destination, queue = [start])
    return puts "Dude, the Knight is already in cell '#{destination}'." if start == destination

    until queue.empty?
      current_path = queue.shift
      current_vertex = current_path
      current_vertex = current_vertex.last while current_vertex[0].is_a?(Array)
      current_cell = @board.find { |cell| cell.vertex == current_vertex }
      neighbors_to_s = current_cell.neighbors.map(&:vertex) - current_path
      neighbors_to_s.each do |neighbor|
        if current_path[0].is_a?(Array)
          queue << (current_path + [neighbor])
          next
        end
        queue << ([current_path] + [neighbor])
      end
      if queue.any? { |track| track.include?(destination) }
        shortest_path = queue.find { |moves| moves.include?(destination) }
        break
      end
    end

    puts "You made it in #{shortest_path.length - 1} moves!  Here's your path:"
    shortest_path.each { |move| p move }
  end
end

knight = Knight.new

knight.knight_moves([0, 0], [7, 7])
