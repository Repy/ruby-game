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
  @dy = 0
  @dx = -1

  def initialize(x, y)
    super(x, y, @@image)
    @dead = -1
    @dy = 0
    @dx = -1
  end

  def update_y()
    if @dead >= 0
      if @dead == @@deadimage.length() * @@deadframe
        self.vanish()
      end
      self.image = @@deadimage[@dead / @@deadframe]
      @dead += 1
      return
    end
    @dy = @dy + 0.7
    if @dy > $SIZE
      @dy = $SIZE
    end
    if @dy < -$SIZE
      @dy = -$SIZE
    end
    self.y += @dy.to_i()
  end
  def update_x()
    if @dead >= 0
      return
    end
    self.x += @dx
  end

  def action(direction)
    if direction == Direction::DOWN
      self.dead()
      return BlockAction::BOUND
    else
      return BlockAction::DEAD
    end
  end

  def dead()
    @dead = 0
    self.collision_enable = false
  end

  def shot_y(o)
    # 落下中に当たった かつ 前回の位置がブロックより上
    if @dy > 0 and self.y + $SIZE - @dy.to_i() <= o.y
      action = o.action(Direction::DOWN)
      if action == BlockAction::DEAD
        self.dead()
      end
      if action == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y - $SIZE
      end
      if action == BlockAction::BOUND
        @dy = -5
        self.y = o.y - $SIZE
      end
    elsif @dy < 0 # 上昇中に当たった
      action = o.action(Direction::UP)
      if action == BlockAction::DEAD
        self.dead()
      end
      if action == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y + $SIZE
      end
    end
  end
  def shot_x(o)
    if @dx > 0 # 右移動で当たった
      action = o.action(Direction::RIGHT)
      if action == BlockAction::DEAD
        self.dead()
      end
      if action == BlockAction::PUSHBACK
        @dx = -@dx
        self.x = o.x - $SIZE
      end
    elsif @dx < 0 # 左移動で当たった
      action = o.action(Direction::LEFT)
      if action == BlockAction::DEAD
        self.dead()
      end
      if action == BlockAction::PUSHBACK
        @dx = -@dx
        self.x = o.x + $SIZE
      end
    end
  end

end
