if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal
  require_remote "ball.rb"
else
  require "./3.3/dxruby.so"
  require "./ball"
end

Window.fps = 45
Window.bgcolor = C_BLACK
world = World.new()
world.start(20)
Window.loop do
  if Input.key_push?(K_SPACE)
    world.start(20)
  end
  world.update()
  world.draw()
end
