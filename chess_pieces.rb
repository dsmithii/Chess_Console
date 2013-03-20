class Piece

  attr_accessor :location, :color, :display_letter


  def initialize(location, color, display_letter, move_type)
    @location = location
    @color = color
    @display_letter = display_letter.to_sym
    @finite_type = move_type
    @rules = []
  end

  def possible_moves_rule(board, rule, own_color_ok = :yes) ## rule comes in format [row,col]
    piece = nil
    row_add, col_add  = rule[0], rule[1]
    possible_moves_arr = []

    while piece.nil?
      row, col = location[0] + row_add, location[1] + col_add
      return possible_moves_arr  if !board.in_bounds([row, col])

      piece = board.grid[row][col]
      possible_moves_arr << [row, col] if piece.nil? || piece.color != color || scenario != :yes

      #puts "#{display_letter}: #{@finite_type}"
      return possible_moves_arr if @finite_type == :non_sliding

      row_add += rule[0]
      col_add += rule[1]
    end
    possible_moves_arr
  end

  def possible_moves(board,scenario = :real)
    moves = []
    @rules.each { |rule| moves = moves + possible_moves_rule(board, rule, scenario)}
    moves
  end

end

class Rook < Piece

  attr_reader :display_letter
  RULES = [[0,-1],[0,1],[1,0],[-1,0]]

  def initialize (location, color, display_letter)
    super(location, color, display_letter, :sliding)
    @rules = RULES
  end

end

class Bishop < Piece

  attr_reader :display_letter
  RULES = [[1,1],[-1,1],[-1,-1],[1,-1]]

  def initialize (location, color, display_letter)
   super(location, color, display_letter, :sliding)
   @rules = RULES
  end

end

class Queen < Piece

  attr_reader :display_letter
  RULES = [[1,1],[-1,1],[-1,-1],[1,-1],[0,-1],[0,1],[1,0],[-1,0]]

  def initialize (location, color, display_letter)
    super(location, color, display_letter, :sliding)
    @rules = RULES
  end

end

class King < Piece

  attr_reader :display_letter
  RULES = [[1,1],[-1,1],[-1,-1],[1,-1],[0,-1],[0,1],[1,0],[-1,0]]

  def initialize (location, color, display_letter)
    super(location, color, display_letter, :non_sliding)
    @rules = RULES
  end

end

class Knight < Piece

  attr_reader :display_letter
  RULES = [[2,1],[-2,1],[-2,-1],[1,-2],[2,-1],[-1,-2],[-1,2],[1,2]]

  def initialize (location, color, display_letter)
    super(location, color, display_letter, :non_sliding)
    @rules = RULES
  end

end

class Pawn < Piece

  attr_reader :display_letter
  RULES = [1,0]

  def initialize (location, color, display_letter)
    super(location, color, display_letter, :non_sliding)

    @rules = [1,0]
    case location[0] ## initial row
    when 1
      @rules = [-1,0]
    when 6
      @rules = [1,0]
    end
  end

  def possible_moves(board)
    ## if start row, can move 2 or 1

    if (location[0] == 1 && @rules[0] == -1) || (location[0] == 6 && @rules[0] == 1)
      return [ [location[0]+1,location[1]], [location[0]+2,location[1]] ]
    else
      possible_moves_arr = []
      row, col = (location[0] + @rules[0]), location[1]

      piece = board.grid[row][col]
      possible_moves_arr += piece.location if piece.nil?
      col = col-1

      return possible_moves_arr  if !board.in_bounds([row, col])

      2.times do
        piece = board.grid[row][col]
        possible_moves_arr << [row, col] if !piece.nil? && piece.color != color
        col +=2
        return possible_moves_arr if !board.in_bounds([row, col])
      end

      possible_moves_arr
    end
  end

end

