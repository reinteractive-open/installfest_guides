module Fog
  module Compute
    class ProfitBricks
      class Real
        # Start specified virtual server
        #
        # ==== Parameters
        # * serverId<~String> - UUID of a virtual server
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * startServerResponse<~Hash>:
        #     * requestId<~String> - ID of request
        #
        # {ProfitBricks API Documentation}[http://www.profitbricks.com/apidoc/StartServer.html]
        def start_server(server_id)
          soap_envelope = Fog::ProfitBricks.construct_envelope do |xml|
            xml[:ws].startServer {
              xml.serverId(server_id)
            }
          end

          request(
            :expects => [200],
            :method  => "POST",
            :body    => soap_envelope.to_xml
          )
        rescue Excon::Errors::InternalServerError => error
          Fog::Errors::NotFound.new(error)
        end
      end

      class Mock
        def start_server(server_id)

          if server = self.data[:servers].find {
            |attrib| attrib["serverId"] == server_id
          }
            server["virtualMachineState"] = "RUNNING"
            server["provisioningState"] = "AVAILABLE"
          else
            raise Fog::Errors::NotFound.new("The requested server resource could not be found")
          end

          response        = Excon::Response.new
          response.status = 200
          response.body   = {
            "startServerResponse" => {
              "requestId" => Fog::Mock::random_numbers(7)
            }
          }
          response
        end
      end
    end
  end
end
