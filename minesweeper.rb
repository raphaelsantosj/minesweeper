require './board.rb'

class Minesweeper
  def initialize(width, height, mines)
    @width = width
    @height = height
    @num_mines = mines
    @board = board
  end

  def board
    board = Board.new(self)
  end

  def board
    self.instance_variable_get("@board")
  end

  def flag x,y
    if x <= self.board.width && y <= self.board.height
      cell = self.board.body[x-1][y-1]
      if cell!="F"
        self.board.body[x-1][y-1]="F"
      elsif cell=="F"
        self.board.body[x-1][y-1]="."
      end
      true
    end
    false
  end
end

game = Minesweeper.new(2,2,1)
game.board.print_board
game.flag 2,2
game.board.print_board
puts "------------"
game.flag 2,3
game.board.print_board
game.board.board_state({xray: true})