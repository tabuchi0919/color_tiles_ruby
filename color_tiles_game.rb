# frozen_string_literal: true
require './field'
class ColorTilesGame

  def initialize(color: 2, count: 5, height: 5, width: 5)
    @field = Field.new(color: color, count: count, height: height, width: width)
    @score = 0
  end

  def click(h, w)
    @score += @field.exec(h, w)
    puts to_s
  end

  def to_s
    "score: #{@score} \n" + @field.to_s
  end
end
