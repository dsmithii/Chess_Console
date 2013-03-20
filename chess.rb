require 'Debugger.rb'
require './chess_pieces.rb'


class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {[nil]*8}
  end

  def add_piece (piece)
    @grid[piece.location[0]][piece.location[1]] = piece
  end

  def in_bounds(location)
    location[0] >=0 && location[1] >= 0 && location[0] <= 7 && location[1] <= 7
  end

  def draw_pieces() ## FOR DEBUGGING

    @grid.each do |row|
      row.each do |piece|
        if piece.nil?
          print "_ "
        else
          print "#{piece.display_letter.to_s} "
        end
      end
      puts
    end
  end

  def move_to(start_loc,fin_loc) ## returns true if valid move, false if invalid
    start_piece, end_piece = grid[start_loc[0]][start_loc[1]], grid[fin_loc[0]][fin_loc[1]]

    if start_piece.possible_moves(self).include?(fin_loc)

      grid[start_loc[0]][start_loc[1]] = nil
      start_piece.location = fin_loc
      add_piece(start_piece)

      player.pieces.delete(end_piece) unless end_piece.nil?
      puts "Valid Move"
      return true
    end

    puts "Invalid Move"
    return false
  end

  def check()

  end

  def check_mate

  end

  def possible_moves(player)
    moves = []
    player.pieces.each {|piece| moves << piece.possible_moves(self)}
    moves
  end

end



class Player
  attr_accessor :pieces

  def initialize(color)
    pieces = []
    case color
      when :black ##top
        pieces = [Rook.new([0,0], :white, "R")
        ]

      when :white
    end
    @pieces

  end




end


board = Board.new

rook1 = Rook.new([5,5], :white, "R")
rook2 = Rook.new([5,3], :white, "R")
queen = Queen.new([1,1], :white, "q")
bishop = Bishop.new([7,7], :black, "B")
king = King.new([4,2],:white, "k")
knight = Knight.new([5,4], :white, "l")
pawn = Pawn.new([4,4], :black, "P")


board.add_piece (rook1)
board.add_piece (rook2)
board.add_piece (queen)
board.add_piece (bishop)
board.add_piece (king)
board.add_piece (knight)
board.add_piece (pawn)

p "Care about: #{pawn.possible_moves(board)}:"
# puts "0,0"
# p board.grid[0][4]

board.draw_pieces()

puts board.move_to([4,4],[5,5])

board.draw_pieces()



