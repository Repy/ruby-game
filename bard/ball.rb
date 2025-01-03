# frozen_string_literal: true

require "dxruby"

# ゲームの世界
class World
  @@sound_bgm = Sound.new(File.join(__dir__, "bgm.wav"))
  @@sound_dead = Sound.new(File.join(__dir__, "dead.wav"))

  @@width = 640
  @@height = 400

  def initialize
    @balls = []
    @player = nil
    @count = 0
    @out = false
    @level = 45
  end

  # ゲーム内容の初期化
  def start(level)
    @@sound_bgm.stop()
    @@sound_bgm.loop_count = -1
    @@sound_bgm.play()
    @balls = []
    @player = Player.new(@@width, @@height)
    @out = true
    @count = 0
    @level = level.to_i
  end

  # 1フレームごとに実行したい動作
  def update
    if !@out
      return
    end

    # 新規ボール出現
    @count = (@count + 1) % @level
    if @count == 0
      @balls << Ball.new(@@width, @@height, @@width, rand(@@height), -1, rand(-10..10) / 10.0)
    end

    # キー入力制御
    if Input.key_down?(K_UP)
      @player.dy(-1)
    end

    # @ballsのすべての実行
    Sprite.update(@balls)
    # @ballsで無効化されているものを削除
    Sprite.clean(@balls)
    # @player単体で実行
    @player.update()

    # 衝突確認
    if @player.check(@balls).length > 0
      @out = false
      @@sound_bgm.stop()
      @@sound_dead.play()
    end
  end

  # 1フレームごとに描画したい動作
  def draw
    # @ballsのすべてを描画
    Sprite.draw(@balls)
    # @player単体で描画
    @player.draw()
  end
end

# プレーヤーの定義
class Player < Sprite
  # Playerの描画したいもの
  @@image = Image.new(30, 30, C_BLUE)
  @dy = 0
  @height = 0

  def initialize(width, height)
    max_x = width - @@image.width
    max_y = height - @@image.width
    super(max_x / 2, max_y, @@image)
    @dy = 0
    @height = max_y
  end

  # Playerの1フレームごとに実行したい内容
  def update
    self.y += @dy
    @dy = @dy + 0.3
    if self.y > @height
      if @dy < 5
        @dy = 0
      end
      @dy = -0.5 * @dy
      self.y = @height
    elsif self.y < 0
      @dy = -@dy
      self.y = 0
    end
  end

  def dy(v)
    @dy += v
  end
end

# ボールの定義
class Ball < Sprite
  # Ballの描画したいもの
  @@image = Image.new(30, 30, C_RED)

  @dx = 0
  @dy = 0
  @width = 0
  @height = 0

  def initialize(width, height, x, y, dx, dy)
    super(x, y, @@image)

    @dx = dx
    @dy = dy
    @width = width - @@image.width
    @height = height - @@image.height
  end

  # Ballの1フレームごとに実行したい内容
  def update
    self.x += @dx
    self.y += @dy
    if self.y > @height
      @dy = -@dy
      self.y = @height
    elsif self.y < 0
      @dy = -@dy
      self.y = 0
    end
    if self.x < 0
      self.vanish()
    end
  end
end
