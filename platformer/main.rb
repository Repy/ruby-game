if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
  require_remote "./config.rb"
  require_remote "./World.rb"
else
  require "./3.3/dxruby.so"
  require "./config"
  require "./World"
end

Window.fps = 45
Window.width=$WINDOW_WIDTH
Window.height=$WINDOW_HEIGHT
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
