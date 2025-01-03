# frozen_string_literal: true

require "dxruby"
require_relative "./config"
require_relative "./world"

Window.fps = 45
Window.width = WINDOW_WIDTH
Window.height = WINDOW_HEIGHT
Window.bgcolor = C_BLACK
world = World.new()
world.start()
Window.loop do
  if Input.key_push?(K_RETURN)
    world.start()
  end
  world.update()
  world.draw()
end
