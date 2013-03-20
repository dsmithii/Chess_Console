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

  def check?(player, opponent) ##1st whose turn it is
    moves_opp = possible_moves(opponent)
    p moves_opp
    p player.king.location
     return moves_opp.include?(player.king.location)
  end

  def check_mate

  end

  def possible_moves(player)
    moves = []
    player.pieces.each {|piece| moves += piece.possible_moves(self)}
    moves
  end

end



class Player
  attr_accessor :pieces, :king

  def initialize(color, piece, king)
    @pieces = [piece]
    @king = king
    @color = color

  end




end


board = Board.new

#
# rook2 = Rook.new([5,3], :white, "R")
# queen = Queen.new([1,1], :white, "q")
# bishop = Bishop.new([7,7], :black, "B")
#
# knight = Knight.new([5,4], :white, "l")
# pawn = Pawn.new([4,4], :black, "P")



king = King.new([4,2],:white, "k")

rook1 = Rook.new([4,4], :black, "R")





p1 = Player.new(:white, king, king)
p2 = Player.new(:black, rook1, nil)
# board.add_piece (rook2)
# board.add_piece (queen)
# board.add_piece (bishop)
board.add_piece (king)
board.add_piece (rook1)
# board.add_piece (knight)
# board.add_piece (pawn)

# p "Care about: #{pawn.possible_moves(board)}:"
# # puts "0,0"
# # p board.grid[0][4]

board.draw_pieces()

puts board.check?(p1,p2)




