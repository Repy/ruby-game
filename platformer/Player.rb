# frozen_string_literal: true

if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal # rubocop:disable Style/MixinUsage
else
  require "dxruby"
end

# プレーヤーの定義
class Player < Sprite
  # Playerの描画したいもの
  @@image = Image.new(30, 30, C_RED)
  @@dead = Image.new(30, 30, C_WHITE)

  attr_accessor :dy
  attr_accessor :dx
  attr_reader :floor

  def initialize(x, y)
    super(x, y, @@image)
    @dy = 0.0
    @dx = 0
    @floor = false
  end

  def update_y()
    @floor = false
    @dy = @dy + 0.7
    if @dy > SIZE
      @dy = SIZE
    end
    if @dy < -SIZE
      @dy = -SIZE
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
    if ! self.check(o)
      puts "Player shot_y not check ${self.x,self.y}"
      return
    end
    # 落下中に当たった かつ 前回の位置がブロックより上
    if @dy > 0 and self.y + SIZE - @dy.to_i() <= o.y
      action = o.action(Direction::DOWN)
      if action == BlockAction::DEAD
        self.image = @@dead
      end
      if action == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y - SIZE
        @floor = true
      end
      if action == BlockAction::BOUND
        @dy = -5
        self.y = o.y - SIZE - 5
        @floor = true
      end
    elsif @dy < 0 # 上昇中に当たった
      action = o.action(Direction::UP)
      if action == BlockAction::DEAD
        self.image = @@dead
      end
      if action == BlockAction::PUSHBACK
        @dy = 0
        self.y = o.y + SIZE
      end
    end
  end

  def shot_x(o)
    if not self.check(o)
      return
    end
    # 右移動で当たった
    if @dx > 0
      action = o.action(Direction::RIGHT)
      if action == BlockAction::DEAD
        self.image = @@dead
      end
      if action == BlockAction::PUSHBACK
        @dx = 0
        self.x = o.x - SIZE
      end
    end
    # 左移動で当たった
    if @dx < 0
      action = o.action(Direction::LEFT)
      if action == BlockAction::DEAD
        self.image = @@dead
      end
      if action == BlockAction::PUSHBACK
        @dx = 0
        self.x = o.x + SIZE
      end
    end
  end

end
