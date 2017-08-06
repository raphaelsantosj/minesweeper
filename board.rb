require './cell.rb'
require 'pry'
class Board
  attr_accessor :body, :width, :height, :num_bombs
  def initialize(width, height, num_bombs)
    self.num_bombs = num_bombs
    self.body = Array.new(height+1) { Array.new(width+1) }
    self.width = width
    self.height = height
    self.initialize_cells
    if body_size > num_bombs
      bombs(num_bombs)
    else
      abort("Quantidade de minas superior ao tamanho do tabuleiro.")
    end
  end

  def initialize_cells
    for i in 1..self.height
      for k in 1..self.width
        self.body[i][k]= Cell.new(".")
      end
    end
  end

  def bombs num_bombs
    puts "#{num_bombs} Minas"
    put_bomb=0
    while put_bomb < num_bombs
      col = rand(1..self.width)
      line = rand(1..self.height)
      if(self.body[line][col].value!="#")
        self.body[line][col].value = "#"
        put_bomb+=1
      end
    end
  end

  def board_state(**args)
    board_state = {unknown_cell: [], clear_cell: [], bomb: [], flag: []}
    for i in 1..self.height
      for k in 1..self.width
        case self.body[i][k].value
        when "."
          board_state[:unknown_cell] << [i,k]
        when "F"
          board_state[:flag] << [i,k]
        when " "
          cell = {cell_coord:  [i,k], neighbors_bombs_count: self.bombs_around(i,k) }
          board_state[:clear_cell] << cell
        end
      end
    end

    if args[:xray]
      for i in 1..self.height
        for k in 1..self.width
          if self.body[i][k].value == "#"
            board_state[:bomb] << [i,k]
          end
        end
      end
    end
    puts board_state
  end

  def has_bomb? x,y
    if self.body[x][y].value=="#"
      true
    else
      false
    end
  end

  def bombs_around x,y
    counter = 0
    for i in 1..8
      for k in 1..8
        h=x+i
        w=y+k
        if self.height>=h && self.width>=w && w>0 && h>0
          puts "Procurando bombas #{h},#{w}"
          if has_bomb? h,w
            counter+=1
          end
        end
      end
    end
    counter
  end

  def show_neighbors x,y
    if self.valid_bounds?(x,y)
      self.body[x][y].neighbors_bombs = self.bombs_around(x,y)
      if !self.discovered?(x,y)
          self.discover(x,y)
        if !self.has_bomb?(x,y) && !self.flag?(x,y) && self.bombs_around(x,y)==0
          show_neighbors(x-1,y-1)
          show_neighbors(x,y-1)
          show_neighbors(x+1,y-1)
          show_neighbors(x-1,y)
          show_neighbors(x+1,y)
          show_neighbors(x-1,y+1)
          show_neighbors(x,y+1)
          show_neighbors(x+1,y+1)
        end
      end
    end
  end

  def valid_bounds? x,y
    x <= self.height && y <= self.width && x>0 && y>0
  end

  def discover x,y
      self.body[x][y].value = " "
  end

  def discovered? x,y
    self.body[x][y].value==" "
  end

  def discovered_count
    counter = 0
    for i in 1..self.height
      for k in 1..self.width
        counter+=1 if self.discovered?(i,k)
      end
    end
    counter
  end

  def body_size
    (self.width)*(self.height)
  end

  def flag_count
    counter = 0
    for i in 1..self.height
      for k in 1..self.width
        counter+=1 if self.flag?(i,k)
      end
    end
    counter
  end

  def flag? x,y
    self.body[x][y].value == "F"
  end

  def board_format
    {
      unknown_cell: '.',
      clear_cell: ' ',
      bomb: '#',
      flag: 'F'
    }
  end

  def print_board
    for i in 1..self.height
      print "#{i}:  |"
      for k in 1..self.width
        print "#{self.body[i][k].value}|"
      end
      print "\n"
    end
    print "\n"
  end
end
