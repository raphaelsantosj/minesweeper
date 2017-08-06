class Cell
  attr_accessor :value, :neighbors_bombs
  def initialize(value)
    self.value = value
    self.neighbors_bombs = 0
  end
end
