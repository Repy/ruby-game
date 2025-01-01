# frozen_string_literal: true

if RUBY_PLATFORM == "opal"
  require "dxopal"
  include DXOpal # rubocop:disable Style/MixinUsage
  require_remote "./config.rb"
  require_remote "./world.rb"
else
  require "dxruby"
  require_relative "./config"
  require_relative "./world"
end

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
