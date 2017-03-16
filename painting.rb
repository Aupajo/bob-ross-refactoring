class Painting
  LOCATIONS = { tree: "🌲", river: "🌊", cloud: "☁️", mountain: "🗻", canvas: "." }.freeze

  def initialize(width, height)
    @width = width
    @height = height
    @items = []
  end

  def value
    score, num_trees, num_mountains = [0] * 3

    @items.each do |item|
      if item[:type] == :tree
        num_trees += 1
      elsif item[:type] == :mountain
        num_mountains += 1
        score += 2
        if num_mountains > 3
          score -= 7
        end
      elsif item[:type] == :cloud
        if item[:y] < 2
          score += 1
        else
          score -= 1
        end
      elsif item[:type] == :river
        score += 1

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
          score += 2 if at(x, y) == :river
        end
      end
    end

    tree_score = num_trees
    tree_score += 5 if num_trees > 3

    if tree_score > 10
      tree_score = 10
    end

    score += tree_score

    score
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
end
