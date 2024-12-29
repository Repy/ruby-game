if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
else
  require "./3.3/dxruby.so"
end

# プレーヤーの定義
class Player < Sprite
  # Playerの描画したいもの
  @@image = Image.new(30, 30, C_RED)
  attr_accessor :dy
  @dy = 0
  attr_accessor :dx
  @dx = 0
  attr_reader :floor
  @floor = false

  def initialize(x, y)
    super(x, y, @@image)
    @dy = 0.0
    @dx = 0
  end

  def update_y()
    @floor = false
    @dy = @dy + 0.5
    if @dy > $SIZE
      @dy = $SIZE
    end
    if @dy < -$SIZE
      @dy = -$SIZE
    end
    self.y += @dy.to_i()
  end

  def update_x()
    if Input.key_down?(K_LEFT)
      @dx -= 2
    end
    if Input.key_down?(K_RIGHT)
      @dx += 2
    end
    if @dx > 5
      @dx = 5
    end
    if @dx > 0
      @dx -= 1
    end
    if @dx < -5
      @dx = -5
    end
    if @dx < 0
      @dx += 1
    end
    self.x += @dx
  end

  def shot_y(o)
    # 落下中に当たった
    if @dy > 0
      if o.action(Direction::DOWN) == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y - $SIZE
        @floor = true
      end
    end
    # 上昇中に当たった
    if @dy < 0
      if o.action(Direction::UP) == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y + $SIZE
      end
    end
  end

  def shot_x(o)
    # 右移動で当たった
    if @dx > 0
      if o.action(Direction::RIGHT) == BlockAction::PUSHBACK
        @dx = 0
        self.x = o.x - $SIZE
      end
    end
    # 左移動で当たった
    if @dx < 0
      if o.action(Direction::LEFT) == BlockAction::PUSHBACK
        @dx = 0
        self.x = o.x + $SIZE
      end
    end
  end

end
