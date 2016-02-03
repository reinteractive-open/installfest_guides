module Fog
  module Models
    module ProfitBricks
      class Base < Fog::Model
        def wait_for(timeout=Fog.timeout, interval=5, &block)
          super
        end
      end
    end
  end
end
