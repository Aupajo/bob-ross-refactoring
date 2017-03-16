require "./painting"
require "minitest/autorun"

# Hint: install minitest-color and run `ruby painting_spec.rb --color` for red/green

describe Painting do
  before do
    @painting = Painting.new(10, 5)
  end

  it "can have trees" do
    @painting.at(0, 0).must_equal :canvas
    @painting.add(:tree).at(0, 0)
    @painting.at(0, 0).must_equal :tree
  end

  it "can have clouds" do
    @painting.at(1, 1).must_equal :canvas
    @painting.add(:cloud).at(1, 1)
    @painting.at(1, 1).must_equal :cloud
  end

  it "can have rivers" do
    @painting.at(9, 4).must_equal :canvas
    @painting.add(:river).at(9, 4)
    @painting.at(9, 4).must_equal :river
  end

  it "can have mountains" do
    @painting.at(3, 3).must_equal :canvas
    @painting.add(:mountain).at(3, 3)
    @painting.at(3, 3).must_equal :mountain
  end

  it "cannot paint out of bounds" do
    -> { @painting.add(:mountain).at(-1, -1) }.must_raise Painting::OutOfBounds
    -> { @painting.add(:river).at(10, 5) }.must_raise Painting::OutOfBounds
  end

  it "cannot paint over an existing object" do
    @painting.add(:river).at(1, 1)
    -> { @painting.add(:mountain).at(1, 1) }.must_raise Painting::AlreadyPaintedError
  end

  describe "value" do
    it "has a starting value of 0" do
      @painting.value.must_equal 0
    end

    it "gets one point for each tree" do
      @painting.add(:tree).at(0, 0)
      @painting.value.must_equal 1
      @painting.add(:tree).at(2, 2)
      @painting.value.must_equal 2
    end

    it "gets a bonus five points if there are at least four trees" do
      4.times { |i| @painting.add(:tree).at(0, i) }
      @painting.value.must_equal 9
    end

    it "can get no more than 10 points from trees" do
      10.times { |i| @painting.add(:tree).at(i, 0) }
      @painting.value.must_equal 10
    end

    it "gets 2 points for each mountain" do
      @painting.add(:mountain).at(0, 0)
      @painting.value.must_equal 2
    end

    it "gets -5 points for each mountain over the first three" do
      3.times { |i| @painting.add(:mountain).at(i, 0) }
      @painting.value.must_equal 6
      @painting.add(:mountain).at(4, 0)
      @painting.value.must_equal 1
      @painting.add(:mountain).at(5, 0)
      @painting.value.must_equal -4
    end

    it "gets one point for each cloud in the first two rows" do
      @painting.add(:cloud).at(0, 0)
      @painting.value.must_equal 1
      @painting.add(:cloud).at(0, 1)
      @painting.value.must_equal 2
    end

    it "gets negative one point for each cloud after the first two rows" do
      @painting.add(:cloud).at(0, 2)
      @painting.value.must_equal -1
      @painting.add(:cloud).at(0, 3)
      @painting.value.must_equal -2
    end

    it "gets one point for each river" do
      @painting.add(:river).at(0, 0)
      @painting.value.must_equal 1
    end

    it "gets a bonus points every time a river has a river in an adjacent square" do
      @painting.add(:river).at(0, 0)
      @painting.value.must_equal 1
      @painting.add(:river).at(1, 1)
      @painting.value.must_equal 6
      @painting.add(:river).at(0, 1)
      @painting.value.must_equal 15
      @painting.add(:river).at(1, 0)
      @painting.value.must_equal 28
      @painting.add(:river).at(4, 4)
      @painting.value.must_equal 29
    end
  end

  it "can render the painting" do
    @painting.add(:cloud).at(2, 0)
    @painting.add(:cloud).at(6, 0)
    @painting.add(:cloud).at(3, 1)

    @painting.add(:tree).at(5, 1)
    @painting.add(:tree).at(3, 2)
    @painting.add(:tree).at(6, 4)

    @painting.add(:river).at(6, 2)
    @painting.add(:river).at(8, 3)
    @painting.add(:river).at(2, 4)

    @painting.add(:mountain).at(4, 3)

    @painting.render.must_equal <<~ART
      ..☁️...☁️...
      ...☁️.🌲....
      ...🌲..🌊...
      ....🗻...🌊.
      ..🌊...🌲...
    ART
  end
end
