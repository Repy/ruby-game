if RUBY_PLATFORM == 'opal'
  require 'dxopal'
  include DXOpal
  require_remote './Floor.rb'
  require_remote './Player.rb'
else
  require 'dxruby'
  require_relative './Floor'
  require_relative './Player'
end

# ゲームの世界
class World
  def initialize
    @floor = []
    @player = Player.new(0, 0)
  end

  # ゲーム内容の初期化
  def start
    @floor = []
    for y in 0...$MAP.length do
      for x in 0...$MAP.length do
        @floor.append(Floor.new(x * $SIZE, y * $SIZE)) if $MAP[y][x] == 1
      end
    end
    @player = Player.new($SIZE, $SIZE)
  end

  # 1フレームごとに実行したい動作
  def update
    # 左右移動
    @player.update_x
    # 衝突確認
    Sprite.check(@player, @floor, shot = :shot_x)

    # 上下移動
    @player.update_y
    # 衝突確認
    Sprite.check(@player, @floor, shot = :shot_y)
    # 接地中のみジャンプ
    return unless @player.floor and Input.key_down?(K_UP)

    @player.dy = -10
  end

  # 1フレームごとに描画したい動作
  def draw
    # @floorのすべてを描画
    Sprite.draw(@floor)
    # @player単体で描画
    @player.draw
  end
end
