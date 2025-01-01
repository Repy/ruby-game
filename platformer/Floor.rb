if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
else
  require "dxruby"
end

# 床の定義
class Floor < Sprite
  # 床の繰り返しパターン
  @@image = Image.new($SIZE, $SIZE, C_GREEN)

  def initialize(x, y)
    super(x,y,@@image)
  end

  def update()
  end

end
