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

  def move_to(start_loc,fin_loc,scenario=:real_scenario) ## returns true if valid move, false if invalid
    start_piece, end_piece = grid[start_loc[0]][start_loc[1]], grid[fin_loc[0]][fin_loc[1]]

    if start_piece.possible_moves(self).include?(fin_loc)

      grid[start_loc[0]][start_loc[1]] = nil
      start_piece.location = fin_loc
      add_piece(start_piece)
      player.pieces.delete(end_piece) if !end_piece.nil? && scenario == :real_scenario

      return :valid_move
    end

      return :invalid_move
  end

  def check?(king_location, opponent, hyp = :no)
    possible_moves(opponent, hyp).include?(king_location)
  end ### test.

  def check_mate?(player, opponent) ## Player = person_under_check
    return false if !check?(player.king.location, opponent)

    possible_moves_king = player.king.possible_moves(self)
    possible_moves_king.each {|move| return false unless check?(move, opponent)}

    ## checking for blocks, if all opponents pieces cannot be blocked, CHECK_MATE.
    opponent.pieces.all? do |piece|
      pos_in_danger = (piece.possible_moves(self) & possible_moves_king) + piece.location
      !can_block?(pos_in_danger, player, opponent)
    end
  end

  def can_block?(threatening_moves, player, opponent) ## player: potentially in check_mate
    player.pieces.each do |piece|

       (threatening_moves & piece.possible_moves(self)).each do |block|
         hyp_board = self.dup
         hyp_board.move_to(piece.location, block, :hypothetical) ## should not move originial piece
         return true unless hyp_board.check?(player.king.location, opponent)
       end

    end
    false
  end

  def possible_moves(player, own_color_ok = :yes)
    moves = []
    player.pieces.each {|piece| moves += piece.possible_moves(self, own_color_ok)}
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

# rook2 = Rook.new([5,3], :white, "R")
# queen = Queen.new([1,1], :white, "q")
# bishop = Bishop.new([7,7], :black, "B")
#
# knight = Knight.new([5,4], :white, "l")
# pawn = Pawn.new([4,4], :black, "P")



piece1 = King.new([7,7],:white, "k")
piece2 = Bishop.new([5,7], :black, "b")
piece3 = Queen.new([7,0], :black, "Q")



p1 = Player.new(:white, piece1, piece1)
p2 = Player.new(:black, piece3, nil)
p2.pieces << piece2



board.add_piece (piece1)
board.add_piece (piece2)
board.add_piece (piece3)

p "Knight Moves #{piece3.possible_moves(board)}"
p "Player2 #{p2.pieces}"

board.draw_pieces()

puts "check mate #{board.check_mate?(p1,p2)}"





