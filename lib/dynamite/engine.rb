module Dynamite
  module Rails
    class Engine < ::Rails::Engine
		paths.app.assets = "assets"
    end
  end
end
