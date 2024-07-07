require "dxopal"
include DXOpal

class World
  @balls = []
  @player = nil
  @width = 640
  @height = 400
  @out = false
  @count = 0

  def initialize
    @balls = []
    @player = []
    @width = 640
    @height = 400
    @out = false
  end

  def start
    @balls = []
    @player = Player.new(@width, @height)
    @out = true
    @count = 0
  end

  def update
    if !@out
      return
    end
    @count += 1
    @count = @count % 45
    if @count == 0
      @balls << Ball.new(@width, @height, @width, rand(@height), -1, rand(-10..10)/10)
    end


    if Input.key_down?(K_UP)
      @player.dy(-1)
    end
    Sprite.update(@balls)
    Sprite.clean(@balls)
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
  @dy = 0
  @height = 0

  def initialize(width, height)
    max_x = width - @@image.width
    max_y = height - @@image.width
    super(max_x / 2, max_y, @@image)
    @dy = 0
    @height = max_y
  end

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
