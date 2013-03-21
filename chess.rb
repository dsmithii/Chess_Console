require 'Debugger.rb'
require './chess_pieces.rb'

class Board

  attr_accessor :grid

  def initialize(grid= Array.new(8) {[nil]*8})
    @grid = grid
  end

  def add_piece(piece)
    @grid[piece.location[0]][piece.location[1]] = piece
  end

  def in_bounds(location)
    location[0] >=0 && location[1] >= 0 && location[0] <= 7 && location[1] <= 7
  end

  def move_to(start_loc,fin_loc,player) ## returns true if valid move, false if invalid
    start_piece, end_piece = grid[start_loc[0]][start_loc[1]], grid[fin_loc[0]][fin_loc[1]]

    if start_piece.possible_moves(self).include?(fin_loc)

      grid[start_loc[0]][start_loc[1]] = nil
      start_piece.location = fin_loc
      add_piece(start_piece)
      player.pieces.delete(end_piece) if !end_piece.nil?
      :valid_move
    else
      :invalid_move
    end
  end

  def check?(king_location, opponent, player)
    hyp_board = self.deep_dup
    hyp_board.move_to(player.king.location, king_location, player)
    hyp_board.possible_moves(opponent.color).include?(king_location)
  end ### test.

  def check_mate?(player, opponent) ## Player = person_under_check
    return false if !check?(player.king.location, opponent, player)

    possible_moves_king = player.king.possible_moves(self)

    possible_moves_king.each {|move| return false unless check?(move, opponent, player)}

    ## checking for blocks, if all opponents pieces cannot be blocked, CHECK_MATE.

    (player.pieces - [player.king]).each do |piece|

      piece.possible_moves(self).each do |move|
        hyp_board = self.deep_dup
        hyp_board.move_to(piece.location, move, player)
        return false if !hyp_board.check?(player.king.location, opponent, player)
      end
    end
    true
  end

  def deep_dup
    new_grid = Array.new(8) {[nil]*8}
    self.grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece == nil
        new_grid[i][j] = piece.dup
      end
    end

    Board.new(new_grid)
  end

  def possible_moves(color)
    moves = []
    grid.each do |row|
      row.each do |piece|
        next if piece == nil
        moves += piece.possible_moves(self) if piece.color == color
      end
    end
    moves
  end

end

class Player
  attr_accessor :pieces, :king, :color

  def initialize(color, board)
    @color = color

    case color
      when :white
        row, pawn_row = 7, 6
      when :black
        row, pawn_row = 0, 1
    end

      @pieces = [
      Rook.new([row,0], color, "#{if color == :white then "r" else "R" end}"),
      Rook.new([row,7], color, "#{if color == :white then "r" else "R" end}"),
      Knight.new([row,1], color, "#{if color == :white then "h" else "H" end}"),
      Knight.new([row,6], color, "#{if color == :white then "h" else "H" end}"),
      Bishop.new([row,2], color, "#{if color == :white then "b" else "B" end}"),
      Bishop.new([row,5], color, "#{if color == :white then "b" else "B" end}"),
      Queen.new([row,4], color, "#{if color == :white then "q" else "Q" end}")
      ]
      @king = King.new([row,3], color, "#{if color == :white then "k" else "K" end}")
      pieces << @king
      8.times {|col| pieces << Pawn.new([pawn_row,col], color, "#{if color == :white then "p" else "P" end}")}

      @board = board
      pieces.each {|piece| @board.add_piece(piece)}
  end

end

class ChessUI

  def initialize
    @board = Board.new
    @player1 = Player.new(:white, @board)
    @player2 = Player.new(:black, @board)
  end

  def draw_pieces ## FOR DEBUGGING
    puts "   0 1 2 3 4 5 6 7"
    puts "   - - - - - - - -"
    @board.grid.each_with_index do |row,i|
      print "#{i}: "
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

  def get_move_coord
    choice = gets.chomp
    choice.split(" ").map!(&:to_i)
  end

  def play

    players = [@player1, @player2]

    until @board.check_mate?(players[0], players[1])
      players[0], players[1] = players[1], players[0]
      draw_pieces

      while true
        puts "#{players[0].color} player: Enter coordinates of the piece you want to move"
        start =  get_move_coord()
        puts "Enter coordinates you want to move to"
        finish =  get_move_coord()
       # p "Debug: #{@board.grid[start[0]][start[1]].possible_moves(@board)}, location: #{@board.grid[start[0]][start[1]].location}"

        next if @board.grid[start[0]][start[1]].nil?
        break if @board.move_to(start, finish, players[0]) == :valid_move
      end


      if @board.check?(players[0].king.location, players[1], players[0])
        puts "#{players[0].color} player is under check"
      elsif @board.check_mate?(players[0], players[1])
        puts "#{players[0].color} player, checkmate. you lose."
      end

    end
    puts "game over"

  end

end

ChessUI.new.play



