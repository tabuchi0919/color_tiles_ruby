require './color_tiles_game'

class Field
  attr_accessor :area

  EMPTY = -1
  MOVES = [
    [1, 0], [-1, 0], [0, 1], [0, -1]
  ].freeze

  def initialize(color: 2, count: 5, height: 4, width: 4)
    raise ArgumentError if color * count >= height * width

    @color = color
    @count = count
    @height = height
    @width = width
    @area = (
      Array.new(color) { |c| [c] * count }.flatten +
      Array.new(height * width - color * count, EMPTY)
    ).shuffle.each_slice(width).map(&:itself)
  end

  def exec(h, w)
    raise ArgumentError unless contains?(h, w)

    return unless @area[h][w] == EMPTY

    targets = MOVES.map do |move|
      cur = [h, w]
      loop do
        cur[0] += move[0]
        cur[1] += move[1]

        break unless contains?(cur[0], cur[1])

        color = @area[cur[0]][cur[1]]
        next if color == EMPTY

        break [cur, color]
      end
    end.compact

    targets.group_by { |target| target[1] }.reject { |_k, v| v.one? }.values.flatten(1).each do |cur, _color|
      @area[cur[0]][cur[1]] = EMPTY
    end

    puts to_s
  end

  def to_s
    @area.map do |row|
      row.map { |cell| cell == EMPTY ? '#' : cell.to_s }.join
    end.join("\n")
  end

  def score
    @color * @count - @height * @width + @area.flatten.count(&:negative?)
  end

  private

  def contains?(h, w)
    h >= 0 && h < @height && w >= 0 && w < @width
  end

end
