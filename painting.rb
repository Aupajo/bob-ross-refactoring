class Painting
  class OutOfBounds < StandardError; end
  class AlreadyPaintedError < StandardError; end

  class Paintable
    attr_reader :type
    def initialize(type)
      @type = type
    end

    def render
      case type
      when :tree      then "🌲"
      when :river     then "🌊"
      when :cloud     then "☁️"
      when :mountain  then "🗻"
      end
    end
  end

  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def items
    @items ||= height.times.map { ("." * width) << "\n" }.join
  end

  def value
    score = 0
    num_trees = 0
    num_mountains = 0

    for item in items
      if item[:type].type == :tree
        num_trees += 1
      elsif item[:type].type == :mountain
        num_mountains += 1
        score += 2
        if num_mountains > 3
          score -= 7
        end
      elsif item[:type].type == :cloud
        if item[:y] < 2
          score += 1
        else
          score -= 1
        end
      elsif item[:type].type == :river
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
    @painting_item = Paintable.new(item)
    self
  end

  def at(x, y)
    if @painting_item
      #located = items.find { |item| item[:x] == x && item[:y] == y }
      items[((y + 1) * width) + x] = @painting_item.render

      #if located
      #  raise AlreadyPaintedError, "at (#{x}, #{y})"
      #elsif x < 0 || y < 0 || x > width - 1 || y > height - 1
      #  fail OutOfBounds, "at (#{x}, #{y})"
      #else
      #  items.push({ x: x, y: y, type: @painting_item })
      #end

      @painting_item = nil
    else
      located = items.find { |item| item[:x] == x && item[:y] == y }

      if located
        located[:type].type
      else
        :canvas
      end
    end
  end

  def render
    @items
  end



end
