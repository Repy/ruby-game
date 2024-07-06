require "dxopal"
include DXOpal

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

  def start
    @balls = []
    @balls << Ball.new(@width, @height,rand(@width),20, 10, 0)
    @balls << Ball.new(@width, @height,rand(@width),50, 7, 0)
    @balls << Ball.new(@width, @height,rand(@width),70, 5, 0)
    @balls << Ball.new(@width, @height,rand(@width),100, 3, 0)
    @player = Player.new(@width, @height)
    @out = true
  end

  def update
    if !@out
      return
    end
    if Input.key_down?(K_LEFT)
      @player.dx(-2)
    end
    if Input.key_down?(K_RIGHT)
      @player.dx(2)
    end
    Sprite.update(@balls)
    @player.update()
    if @player.check(@balls).length > 0
      @out = false
    end
  end

  def draw
    Sprite.draw(@balls)
    @player.draw()
  end
end

class Player < Sprite
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

class Ball < Sprite
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
