# frozen_string_literal: true

require "dxruby"
require_relative "./ball"

Window.fps = 45
Window.bgcolor = C_BLACK
Window.create()
world = World.new()
world.start(20)
Window.loop do
  if Input.key_push?(K_SPACE)
    world.start(20)
  end
  world.update()
  world.draw()
end
