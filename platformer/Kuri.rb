if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
else
  require "./3.3/dxruby.so"
end

# 敵の定義
class Kuri < Sprite
  # Playerの描画したいもの
  @@image = Image.new(30, 30, [0xA0, 0x40, 0x00])
  @@deadimage = [
    Image.new(30, 30, [0x80, 0x30, 0x00]),
    Image.new(30, 30, [0x40, 0x20, 0x00]),
    Image.new(30, 30, [0x20, 0x10, 0x00])
  ]
  @@deadframe = 5

  @dead = -1

  def initialize(x, y)
    super(x, y, @@image)
    @dead = -1
  end

  def update()
    if @dead == @@deadimage.length() * @@deadframe
      self.vanish()
    end
    if @dead >= 0
      self.image = @@deadimage[@dead / @@deadframe]
      @dead += 1
    end
  end

  def action(direction)
    if direction == Direction::DOWN
      @dead = 0
      #self.collision_enable = false
      return BlockAction::BOUND
    else
      return BlockAction::DEAD
    end
  end

end
