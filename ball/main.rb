# frozen_string_literal: true

if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal # rubocop:disable Style/MixinUsage
  require_remote "ball.rb"
else
  require "dxruby"
  require_relative "./ball"
end

Window.fps = 45
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
