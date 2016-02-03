module Fog
  module Parsers
    module Compute
      module ProfitBricks
        class GetDataCenterState < Fog::Parsers::Compute::ProfitBricks::Base
          def reset
            @response = { 'getDataCenterStateResponse' => {} }
          end

          def end_element(name)
            case name
            when 'return'
              @response['getDataCenterStateResponse'][name] = value
            end
          end
        end
      end
    end
  end
end
