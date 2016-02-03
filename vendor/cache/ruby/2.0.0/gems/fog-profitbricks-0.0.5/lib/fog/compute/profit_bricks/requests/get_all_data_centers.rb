module Fog
  module Compute
    class ProfitBricks
      class Real
        def get_all_data_centers
          soap_envelope = Fog::ProfitBricks.construct_envelope do |xml|
            xml[:ws].getAllDataCenters
          end

          request(
            :expects => [200],
            :method  => "POST",
            :body    => soap_envelope.to_xml,
            :parser  => Fog::Parsers::Compute::ProfitBricks::GetAllDataCenters.new
          )
        end
      end

      class Mock
        def get_all_data_centers
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
            "getAllDataCentersResponse" => self.data[:datacenters]
          }
          response
        end
      end
    end
  end
end
