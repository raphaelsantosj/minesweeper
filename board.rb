class Board
  attr_accessor :width, :height
  def initialize(minesweeper)
    self.height = minesweeper.instance_variable_get("@height")
    self.width = minesweeper.instance_variable_get("@width")
    mines = minesweeper.instance_variable_get("@mines")
    @body = Array.new(width) { Array.new(height,'.') }
    put_mines(mines)
  end

  def body
    self.instance_variable_get("@body")
  end

  def put_mines mines
    for i in 0..mines
      mine_x = rand(0..self.width-1)
      mine_y = rand(0..self.height-1)
      if(self.body[mine_x][mine_y]!="#")
        self.body[mine_x][mine_y] = "#"
      end
    end
  end

  def board_state(*args)
    if :xray
      ###
    end
  end

  def print_board
    for i in 0..self.width-1
      for k in 0..self.height-1
        print self.body[i][k]
      end
      print "\n"
    end
  end
end