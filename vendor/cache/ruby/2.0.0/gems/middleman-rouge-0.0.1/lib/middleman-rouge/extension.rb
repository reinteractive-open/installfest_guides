module Middleman
  module Rouge
    class << self
      def registered(app)
        require "redcarpet"
        require "rouge"
        require 'rouge/plugins/redcarpet'
        Redcarpet::Render::HTML.send :include, ::Rouge::Plugins::Redcarpet
      end
      alias :included :registered
    end
  end
end