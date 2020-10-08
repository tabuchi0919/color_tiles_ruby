# frozen_string_literal: true

class ColorTilesGame
  EMPTY = -1
  MOVES = [
    [1, 0], [-1, 0], [0, 1], [0, -1]
  ].freeze

  def initialize(color: 10, count: 20, height: 15, width: 23)
    raise ArgumentError if color * count >= height * width

    @color = color
    @count = count
    @height = height
    @width = width
    @field = (
      Array.new(color) { |c| [c] * count }.flatten +
      Array.new(height * width - color * count, EMPTY)
    ).shuffle.each_slice(width).map(&:itself)
  end

  def click(h, w)
    raise ArgumentError unless in_field?(h, w)

    return unless @field[h][w] == EMPTY

    targets = MOVES.map do |move|
      cur = [h, w]
      loop do
        cur[0] += move[0]
        cur[1] += move[1]

        break unless in_field?(cur[0], cur[1])

        color = @field[cur[0]][cur[1]]
        next if color == EMPTY

        break [cur, color]
      end
    end.compact

    targets.group_by { |target| target[1] }.reject { |_k, v| v.one? }.values.flatten(1).each do |cur, _color|
      @field[cur[0]][cur[1]] = -1
    end

    puts to_s
  end

  def to_s
    @field.map do |row|
      row.map { |cell| cell == -1 ? '#' : cell.to_s }.join
    end.join("\n")
  end

  def score
    @color * @count - @height * @width + @field.flatten.count(&:negative?)
  end

  private

  def in_field?(h, w)
    h >= 0 && h < @height && w >= 0 && w < @width
  end
end
