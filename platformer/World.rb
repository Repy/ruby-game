# frozen_string_literal: true

if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal # rubocop:disable Style/MixinUsage
  require_remote "./floor.rb"
  require_remote "./player.rb"
else
  require "dxruby"
  require_relative "./floor"
  require_relative "./player"
  require_relative "./kuri"
end

# ゲームの世界
class World
  @floor = []
  @player = Player.new(0, 0)
  @enemy = []

  def initialize()
    @floor = []
    @player = Player.new(0, 0)
    @enemy = []
  end

  # ゲーム内容の初期化
  def start()
    @floor = []
    for y in 0...MAP.length() do
      for x in 0...MAP[0].length() do
        case MAP[y][x]
        when 1
          @floor.append(Floor.new(x * SIZE, y * SIZE, FloorType::PUSHBACK_FLOOR))
        when 2
          @floor.append(Floor.new(x * SIZE, y * SIZE, FloorType::PASSAGE_FLOOR))
        when 3
          @enemy.append(Kuri.new(x * SIZE, y * SIZE))
        end
      end
    end
    @player = Player.new(SIZE, SIZE)
  end

  # 1フレームごとに実行したい動作
  def update()
    # 左右移動
    @player.update_x()
    # 衝突確認
    Sprite.check(@player, @floor, :shot_x)
    Sprite.check(@player, @enemy, :shot_x)

    # 上下移動
    @player.update_y()
    # 衝突確認
    Sprite.check(@player, @floor, :shot_y)
    Sprite.check(@player, @enemy, :shot_y)
    # 接地中のみジャンプ
    if @player.floor && Input.key_down?(K_SPACE)
      @player.dy = -14
    end

    # @enemyのすべてをupdate
    for e in @enemy do
      e.update_y()
    end
    Sprite.check(@enemy, @floor, :shot_y)
    for e in @enemy do
      e.update_x()
    end
    Sprite.check(@enemy, @floor, :shot_x)
  end

  # 1フレームごとに描画したい動作
  def draw()
    Window.ox = @player.x - 10 * SIZE
    # @floorのすべてを描画
    Sprite.draw(@floor)
    # @enemyのすべてを描画
    Sprite.draw(@enemy)
    # @player単体で描画
    @player.draw()
  end
end
