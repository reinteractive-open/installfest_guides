module Fog
  module Parsers
    module Compute
      module ProfitBricks
        class ResetServer < Fog::Parsers::Compute::ProfitBricks::Base
          def reset
            @response = { 'resetServerResponse' => {} }
          end

          def end_element(name)
            case name
            when 'requestId'
              @response['resetServerResponse'][name] = value.to_i
            end
          end
        end
      end
    end
  end
end
