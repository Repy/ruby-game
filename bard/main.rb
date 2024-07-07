require "dxopal"
include DXOpal
require_remote "ball.rb?#{Time.now}"

Window.fps = 45
Window.load_resources do
  Window.bgcolor = C_BLACK
  world = World.new()
  world.start()
  Window.loop do
    if Input.key_push?(K_SPACE)
      world.start()
    end
    world.update()
    world.draw()
  end
end
