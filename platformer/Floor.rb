if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
  require "./types.rb"
else
  require "./3.3/dxruby.so"
  require "./types"
end

class FloorType
  PUSHBACK_FLOOR = 1
  PASSAGE_FLOOR = 2
end

# 床の定義
class Floor < Sprite
  # 床の繰り返しパターン
  @@image1 = Image.new($SIZE, $SIZE, C_GREEN)
  @@image2 = Image.new($SIZE, $SIZE, C_YELLOW)

  @floortype = FloorType::PUSHBACK_FLOOR

  def initialize(x, y, floortype)
    if floortype == FloorType::PUSHBACK_FLOOR
      super(x,y,@@image1)
    else
      super(x,y,@@image2)
    end
    @floortype = floortype
  end

  def update()
  end

  def action(direction)
    if @floortype == FloorType::PUSHBACK_FLOOR
      return BlockAction::PUSHBACK
    end
    if @floortype == FloorType::PASSAGE_FLOOR
      if direction == Direction::DOWN
        return BlockAction::PUSHBACK
      end
    end
    return BlockAction::PASSAGE
  end

end
