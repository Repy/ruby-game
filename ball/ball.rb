if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
else
  require "./3.3/dxruby.so"
end

# ゲームの世界
class World
  @balls = []
  @player = nil
  @width = 640
  @height = 400
  @out = false

  def initialize
    @balls = []
    @player = []
    @width = 640
    @height = 400
    @out = false
  end

  # ゲーム内容の初期化
  def start
    @balls = []
    @balls << Ball.new(@width, @height,rand(@width),20, 10, 0)
    @balls << Ball.new(@width, @height,rand(@width),50, 7, 0)
    @balls << Ball.new(@width, @height,rand(@width),70, 5, 0)
    @balls << Ball.new(@width, @height,rand(@width),100, 3, 0)
    @player = Player.new(@width, @height)
    @out = true
  end

  # 1フレームごとに実行したい動作
  def update
    if !@out
      return
    end

    # キー入力制御
    if Input.key_down?(K_LEFT)
      @player.dx(-2)
    end
    if Input.key_down?(K_RIGHT)
      @player.dx(2)
    end

    # @ballsのすべての実行
    Sprite.update(@balls)
    # @player単体で実行
    @player.update()

    # 衝突確認
    if @player.check(@balls).length > 0
      @out = false
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
  @dx = 0
  @width = 0

  def initialize(width, height)
    max_x = width - @@image.width
    max_y = height - @@image.width
    super(max_x / 2,max_y,@@image)

    @dx = 0
    @width = max_x
  end

  # Playerの1フレームごとに実行したい内容
  def update
    self.x += @dx
    if self.x > @width
      @dx = -@dx
      self.x = @width
    elsif self.x < 0
      @dx = -@dx
      self.x = 0
    end
    @dx = @dx*0.90
  end

  def dx(v)
    @dx += v
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
    super(x,y,@@image)

    @dx = dx
    @dy = dy
    @width = width - @@image.width
    @height = height - @@image.height
  end

  # Ballの1フレームごとに実行したい内容
  def update
    self.x += @dx
    self.y += @dy
    if self.x > @width
      @dx = -@dx
      self.x = @width
    elsif self.x < 0
      @dx = -@dx
      self.x = 0
    end
    if self.y > @height
      @dy = -@dy
      self.y = @height
    end
    @dy += 0.5
  end

end
