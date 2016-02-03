require "fog/core"
require "fog/xml"

require File.expand_path('../profitbricks/version', __FILE__)

module Fog
  module Compute
    autoload :ProfitBricks, File.expand_path('../compute/profit_bricks', __FILE__)
  end

  module Models
    module ProfitBricks
      autoload :Base, File.expand_path('../models/profit_bricks/base', __FILE__)
    end
  end

  module Parsers
    autoload :Compute, File.expand_path('../parsers/compute', __FILE__)
  end

  module ProfitBricks
    extend Fog::Provider

    service(:compute, "Compute")

    def self.construct_envelope(&block)
      namespaces = {
          "xmlns"         => "",
          "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
          "xmlns:ws"      => "http://ws.api.profitbricks.com/"
      }

      Nokogiri::XML::Builder.new do |xml|
        xml[:soapenv].Envelope(namespaces) do
          xml[:soapenv].Header
          xml[:soapenv].Body(&block)
        end
      end
    end
  end
end
