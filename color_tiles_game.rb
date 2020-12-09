# frozen_string_literal: true
class ColorTilesGame
  require './field'

  EMPTY = -1
  MOVES = [
    [1, 0], [-1, 0], [0, 1], [0, -1]
  ].freeze

  def initialize(color: 2, count: 5, height: 5, width: 5)
    @field = Field.new(color: color, count: count, height: height, width: width)
  end

  def click(h, w)
    @field.exec(h, w)
    to_s
  end

  def to_s
    @field.area.map do |row|
      row.map { |cell| cell == EMPTY ? '#' : cell.to_s }.join
    end.join("\n")
  end

  def score
    @field.score
  end
end
