class Painting
  LOCATIONS = { tree: "🌲", river: "🌊", cloud: "☁️", mountain: "🗻", canvas: "." }.freeze

  def initialize(width, height)
    @width = width
    @height = height
    @items = []
  end

  def value
    ScoreCalculator.new(@items).value
  end

  def add(item)
    @painting_item = item
    self
  end

  def at(x, y)
    if currently_painting?
      paint!(x, y)
    else
      locate(x, y)[:type]
    end
  end

  def render
    rendered = ""

    for y in 0...@height
      for x in 0...@width
        rendered << LOCATIONS[locate(x, y)[:type]]
      end
      rendered << "\n"
    end

    rendered
  end

  private
  #
  # def canvas
  #   Canvas.new(x, y)
  # end

  def out_of_bounds?(x, y)
    x < 0 || y < 0 || x > @width - 1 || y > @height - 1
  end

  def locate(x, y)
    @items.find { |item| item[:x] == x && item[:y] == y } || { type: :canvas }
  end

  def currently_painting?
    !!@painting_item
  end

  def painted?(x, y)
    locate(x,y)[:type] != :canvas
  end

  def paint!(x, y)
    if painted?(x, y)
      raise AlreadyPaintedError, "at (#{x}, #{y})"
    elsif out_of_bounds?(x, y)
      fail OutOfBounds, "at (#{x}, #{y})"
    else
      @items.push( x: x, y: y, type: @painting_item )
    end

    @painting_item = nil
  end

  class OutOfBounds < StandardError
  end

  class AlreadyPaintedError < StandardError
  end

  class ScoreCalculator

    def initialize(items)
      @items = items
      @score = 0
      @num_trees = 0
      @num_mountains = 0
    end

    def value
      @items.each do |item|
        self.send(item[:type], item)
      end

      tree_score = @num_trees
      tree_score += 5 if @num_trees > 3

      if tree_score > 10
        tree_score = 10
      end
      @score += tree_score
    end

    def tree(item)
      @num_trees += 1
    end

    def mountain(item)
      @num_mountains += 1
      @score += 2
      @score -= 7 if @num_mountains > 3
    end

    def cloud(item)
      if item[:y] < 2
        @score += 1
      else
        @score -= 1
      end
    end

    def river(item)
      @score += 1

      [
        [item[:x] - 1, item[:y] -1],
        [item[:x], item[:y] -1],
        [item[:x] + 1, item[:y] -1],
        [item[:x] - 1, item[:y]],
        [item[:x] + 1, item[:y]],
        [item[:x] - 1, item[:y] + 1],
        [item[:x], item[:y] + 1],
        [item[:x] + 1, item[:y] + 1]
      ].each do |x, y|
        @score += 2 if at(x, y) == :river
      end
    end

    def at(x, y)
      locate(x, y)[:type]
    end

    def locate(x, y)
      @items.find { |item| item[:x] == x && item[:y] == y } || { type: :canvas }
    end

  end
end
