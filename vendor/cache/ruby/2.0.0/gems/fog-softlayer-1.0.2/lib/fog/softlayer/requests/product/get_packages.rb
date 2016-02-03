#
# Author:: Celso Fernandes (<fernandes@zertico.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
module Fog
  module Softlayer
    class Product

      class Mock
        def get_packages
          response = Excon::Response.new
          response.body = fixtures_packages
          response.status = 200
          return response
        end

      end

      class Real
        def get_packages
          request(:product_package, :get_all_objects)
        end
      end
    end
  end
end

module Fog
  module Softlayer
    class Product
      class Mock
        def fixtures_packages
          [
            {
              "firstOrderStepId"=>1,
              "id"=>0,
              "isActive"=>1,
              "name"=>"Additional Products",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>10,
              "isActive"=>1,
              "name"=>"Control Panels for VPS",
              "unitSize"=>nil
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Quad Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>32,
              "isActive"=>1,
              "name"=>"Quad Processor, Quad Core Intel",
              "subDescription"=>"Quad Processor Multi-core Servers",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">dual processor multi core</div>",
              "firstOrderStepId"=>1,
              "id"=>35,
              "isActive"=>1,
              "name"=>"Dual Xeon (Dual Core) Woodcrest/Cloverton - OUTLET",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Single Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>41,
              "isActive"=>1,
              "name"=>"Single Xeon 5500 Series (Nehalem)",
              "subDescription"=>"Single Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Dual Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>42,
              "isActive"=>1,
              "name"=>"Dual Xeon 5500 Series (Nehalem)",
              "subDescription"=>"Dual Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Redundant Power</div>",
              "firstOrderStepId"=>1,
              "id"=>43,
              "isActive"=>1,
              "name"=>"Specialty Server: Redundant Power: Xeon 5500 (Nehalem) Series",
              "subDescription"=>"Specialty Servers: Redundant Power",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>44,
              "isActive"=>1,
              "name"=>"Specialty Server: Mass Storage: Xeon 5500 (Nehalem) Series",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>2
            },
            {
              "description"=>"Virtual Server Instance",
              "firstOrderStepId"=>1,
              "id"=>46,
              "isActive"=>1,
              "name"=>"Cloud Server",
              "subDescription"=>"Virtual Server Instance",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Redundant Power</div>",
              "firstOrderStepId"=>1,
              "id"=>49,
              "isActive"=>1,
              "name"=>"Specialty Server: 4u Redundant power Xeon 5500 (Nehalem) Series",
              "subDescription"=>"Specialty Servers: Redundant Power",
              "unitSize"=>4
            },
            {
              "firstOrderStepId"=>1,
              "id"=>50,
              "isActive"=>1,
              "name"=>"Bare Metal Instance",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Single Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>51,
              "isActive"=>1,
              "name"=>"Single Xeon 3400 Series (Lynnfield)",
              "subDescription"=>"Single Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>52,
              "isActive"=>1,
              "name"=>"Specialty Server: 4u Mass Storage Xeon 5500 (Nehalem) Series",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>4
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Private Network</div>",
              "firstOrderStepId"=>1,
              "id"=>53,
              "isActive"=>1,
              "name"=>"Specialty Server: Private Network: Single Xeon 3400 Series (Lynnfield)",
              "subDescription"=>"Specialty Servers: Private Network",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Private Network</div>",
              "firstOrderStepId"=>1,
              "id"=>54,
              "isActive"=>1,
              "name"=>"Specialty Server: Private Network: Dual Xeon 5500 Series (Nehalem)",
              "subDescription"=>"Specialty Servers: Private Network",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Private Network</div>",
              "firstOrderStepId"=>1,
              "id"=>55,
              "isActive"=>1,
              "name"=>"Specialty Server: Private Network & Redundant Power: Xeon 5500 (Nehalem) Series",
              "subDescription"=>"Specialty Servers: Private Network",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Quad Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>56,
              "isActive"=>1,
              "name"=>"Quad Processor Multi Core Nehalem EX",
              "subDescription"=>"Quad Processor Multi-core Servers",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Colocation Service</div>",
              "firstOrderStepId"=>1,
              "id"=>58,
              "isActive"=>1,
              "name"=>"Colocation Service",
              "unitSize"=>1
            },
            {
              "description"=>"ThePlanet Legacy Placeholder Package",
              "firstOrderStepId"=>1,
              "id"=>60,
              "isActive"=>1,
              "name"=>"ThePlanet Legacy Placeholder Package",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>61,
              "isActive"=>1,
              "name"=>"Virtual Rack MD3000i SAN - HA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>62,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5130 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>63,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5130 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>64,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5520 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>65,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3210 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>66,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5335 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>67,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5520 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>68,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5620 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>69,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5620 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>70,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5620 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>71,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5620 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>72,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5620 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>73,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5620 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>74,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5660 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>75,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5660 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>76,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5660 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>77,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5660 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>78,
              "isActive"=>1,
              "name"=>"Virtual Rack Quad Xeon 7550 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>79,
              "isActive"=>1,
              "name"=>"PC Quad Xeon 7550 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>80,
              "isActive"=>1,
              "name"=>"PR Xeon 3450 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>81,
              "isActive"=>1,
              "name"=>"PR Xeon 3450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>82,
              "isActive"=>1,
              "name"=>"Virtual Rack Pentium G6950 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>83,
              "isActive"=>1,
              "name"=>"PC Pentium G6950 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>84,
              "isActive"=>1,
              "name"=>"Virtual Rack MD1000 DAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>85,
              "isActive"=>1,
              "name"=>"Virtual Rack MD3000 DAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>86,
              "isActive"=>1,
              "name"=>"Virtual Rack MD3000 DAS - HA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>87,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5130 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>88,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5130 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>89,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5335 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>90,
              "isActive"=>1,
              "name"=>"PR Xeon 3060 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>91,
              "isActive"=>1,
              "name"=>"PR Xeon 3060 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>92,
              "isActive"=>1,
              "name"=>"PR Xeon 3210 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>93,
              "isActive"=>1,
              "name"=>"PR Xeon 3210 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>94,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5335 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>95,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5335 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>96,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5405 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>97,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5405 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>98,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5405 - Monster",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>99,
              "isActive"=>1,
              "name"=>"PC Xeon 3360 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>100,
              "isActive"=>1,
              "name"=>"PC Xeon 3360 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>101,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5450 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>102,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>103,
              "isActive"=>1,
              "name"=>"PR Xeon 3040 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>104,
              "isActive"=>1,
              "name"=>"PC Xeon 3210 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>105,
              "isActive"=>1,
              "name"=>"PC Xeon 3210 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Private Rack",
              "firstOrderStepId"=>1,
              "id"=>106,
              "isActive"=>1,
              "name"=>"PR Dual Xeon 5335 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>107,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3360 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>108,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3360 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>109,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5450 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>110,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>111,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3210 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>112,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5130 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>113,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5335 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>114,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5130 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>115,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5405 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>116,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5405 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>117,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5405 - Monster",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>118,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5520 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>119,
              "isActive"=>1,
              "name"=>"PC Dual Xeon 5520 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>120,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5520 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>121,
              "isActive"=>1,
              "name"=>"Virtual Rack Dual Xeon 5520 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>122,
              "isActive"=>1,
              "name"=>"PC Xeon 3450 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Other (PC)",
              "firstOrderStepId"=>1,
              "id"=>123,
              "isActive"=>1,
              "name"=>"PC Xeon 3450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>124,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3450 - SATA",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>125,
              "isActive"=>1,
              "name"=>"Virtual Rack Xeon 3450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Single Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>126,
              "isActive"=>1,
              "name"=>"Single Xeon 1200 Series (Sandy Bridge / Haswell)",
              "subDescription"=>"Single Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"Virtual Rack",
              "firstOrderStepId"=>1,
              "id"=>132,
              "isActive"=>1,
              "name"=>"Virtual Rack Quad Xeon 7450 - SAS",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale XS CCI",
              "firstOrderStepId"=>1,
              "id"=>135,
              "isActive"=>1,
              "name"=>"RightScale XS CCI",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale SM CCI",
              "firstOrderStepId"=>1,
              "id"=>136,
              "isActive"=>1,
              "name"=>"RightScale SM CCI",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale MD CCI",
              "firstOrderStepId"=>1,
              "id"=>137,
              "isActive"=>1,
              "name"=>"RightScale MD CCI",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale LG CCI",
              "firstOrderStepId"=>1,
              "id"=>138,
              "isActive"=>1,
              "name"=>"RightScale LG CCI",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale XL CCI",
              "firstOrderStepId"=>1,
              "id"=>139,
              "isActive"=>1,
              "name"=>"RightScale XL CCI",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>140,
              "isActive"=>1,
              "name"=>"Specialty Server: Mass Storage: QuantaStor",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>141,
              "isActive"=>1,
              "name"=>"Specialty Server: 4u Mass Storage: QuantaStor",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>4
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Single Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>142,
              "isActive"=>1,
              "name"=>"Single Xeon 2000 Series (Sandy Bridge)",
              "subDescription"=>"Single Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Dual Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>143,
              "isActive"=>1,
              "name"=>"Dual Xeon 2000 Series (Sandy Bridge)",
              "subDescription"=>"Dual Processor Multi-core Servers",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: GPU</div>",
              "firstOrderStepId"=>1,
              "id"=>144,
              "isActive"=>1,
              "name"=>"Specialty Server: GPU",
              "subDescription"=>"Specialty Servers: GPU",
              "unitSize"=>3
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Intel Xeon 3460</div>",
              "firstOrderStepId"=>1,
              "id"=>145,
              "isActive"=>1,
              "name"=>"Intel Xeon 3460",
              "subDescription"=>"Intel Xeon 3460",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Sandy Bridge 1270</div>",
              "firstOrderStepId"=>1,
              "id"=>146,
              "isActive"=>1,
              "name"=>"Sandy Bridge 1270",
              "subDescription"=>"Sandy Bridge 1270",
              "unitSize"=>1
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>147,
              "isActive"=>1,
              "name"=>"Specialty Server: 4u Mass Storage Dual Xeon 2000 (Sandy Bridge) Series",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>4
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Specialty Servers: Mass Storage</div>",
              "firstOrderStepId"=>1,
              "id"=>148,
              "isActive"=>1,
              "name"=>"Specialty Server: 2u Mass Storage Dual Xeon 2000 (Sandy Bridge) Series",
              "subDescription"=>"Specialty Servers: Mass Storage",
              "unitSize"=>2
            },
            {
              "description"=>"<div class=\"PageTopicSubHead\">Quad Processor Multi-core Servers</div>",
              "firstOrderStepId"=>1,
              "id"=>158,
              "isActive"=>1,
              "name"=>"Quad Xeon 4000 Series (Sandy Bridge)",
              "subDescription"=>"Quad Processor Multi-core Servers",
              "unitSize"=>4
            },
            {
              "description"=>"RightScale MD (High Mem) CCI",
              "firstOrderStepId"=>1,
              "id"=>161,
              "isActive"=>1,
              "name"=>"RightScale MD (High Mem) CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight LG (High Mem) Private CCI",
              "firstOrderStepId"=>1,
              "id"=>162,
              "isActive"=>1,
              "name"=>"ScaleRight LG (High Mem) Private CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight XS Private CCI",
              "firstOrderStepId"=>1,
              "id"=>163,
              "isActive"=>1,
              "name"=>"ScaleRight XS Private CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight SM Private CCI",
              "firstOrderStepId"=>1,
              "id"=>164,
              "isActive"=>1,
              "name"=>"ScaleRight SM Private CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight MD Private CCI",
              "firstOrderStepId"=>1,
              "id"=>165,
              "isActive"=>1,
              "name"=>"ScaleRight MD Private CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight LG Private CCI",
              "firstOrderStepId"=>1,
              "id"=>166,
              "isActive"=>1,
              "name"=>"ScaleRight LG Private CCI",
              "unitSize"=>1
            },
            {
              "description"=>"RightScale LG (High Mem) CCI",
              "firstOrderStepId"=>1,
              "id"=>168,
              "isActive"=>1,
              "name"=>"RightScale LG (High Mem) CCI",
              "unitSize"=>1
            },
            {
              "description"=>"ScaleRight MD (High Mem) Private CCI",
              "firstOrderStepId"=>1,
              "id"=>169,
              "isActive"=>1,
              "name"=>"ScaleRight MD (High Mem) Private CCI",
              "unitSize"=>1
            },
            {
              "firstOrderStepId"=>1,
              "id"=>173,
              "isActive"=>1,
              "name"=>"VHD Import",
              "unitSize"=>1
            },
            {
              "description"=>"Network Gateway Appliance",
              "firstOrderStepId"=>1,
              "id"=>174,
              "isActive"=>1,
              "name"=>"Network Gateway Appliance",
              "subDescription"=>"Network Gateway Appliance",
              "unitSize"=>1
            },
            {
              "firstOrderStepId"=>1,
              "id"=>192,
              "isActive"=>1,
              "name"=>"Application Delivery Appliance",
              "subDescription"=>"Application Delivery Appliance",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>194,
              "isActive"=>1,
              "name"=>"Load Balancers",
              "subDescription"=>"Load Balancers",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>196,
              "isActive"=>1,
              "name"=>"Network Gateway Appliance Cluster",
              "unitSize"=>1
            },
            {
              "firstOrderStepId"=>1,
              "id"=>198,
              "isActive"=>1,
              "name"=>"Portable Storage",
              "subDescription"=>"Portable Storage",
              "unitSize"=>1
            },
            {
              "description"=>"Bare Metal Server",
              "firstOrderStepId"=>1,
              "id"=>200,
              "isActive"=>1,
              "name"=>"Bare Metal Server",
              "subDescription"=>"Bare Metal Server",
              "unitSize"=>1
            },
            {
              "description"=>"POWER8 TULETA FOR WATSON",
              "firstOrderStepId"=>1,
              "id"=>202,
              "isActive"=>1,
              "name"=>"POWER8 TULETA",
              "unitSize"=>4
            },
            {
              "firstOrderStepId"=>1,
              "id"=>206,
              "isActive"=>1,
              "name"=>"Object Storage",
              "subDescription"=>"Object Storage",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>208,
              "isActive"=>1,
              "name"=>"Content Delivery Network",
              "subDescription"=>"Content Delivery Network",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>210,
              "isActive"=>1,
              "name"=>"SSL Certificate",
              "subDescription"=>"SSL Certificate",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>212,
              "isActive"=>1,
              "name"=>"Message Queue",
              "subDescription"=>"Message Queue",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>216,
              "isActive"=>1,
              "name"=>"Network Attached Storage",
              "subDescription"=>"Network Attached Storage",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>218,
              "isActive"=>1,
              "name"=>"iSCSI Storage",
              "subDescription"=>"iSCSI Storage",
              "unitSize"=>nil
            },
            {
              "firstOrderStepId"=>1,
              "id"=>222,
              "isActive"=>1,
              "name"=>"Consistent Performance Storage",
              "subDescription"=>"Consistent Performance Storage",
              "unitSize"=>1
            },
            {
              "firstOrderStepId"=>1,
              "id"=>226,
              "isActive"=>1,
              "name"=>"Authentication Services",
              "subDescription"=>"Authentication Services",
              "unitSize"=>nil
            },
            {
              "description"=>"Quad Xeon E7-4800 v2 (Ivy Bridge) Series",
              "firstOrderStepId"=>1,
              "id"=>234,
              "isActive"=>1,
              "name"=>"Quad Xeon E7-4800 v2 (Ivy Bridge) Series",
              "subDescription"=>"Quad Xeon E7-4800 v2 (Ivy Bridge) Series",
              "unitSize"=>4
            },
            {
              "description"=>"Network Gateway Appliance (10 Gbps)",
              "firstOrderStepId"=>1,
              "id"=>236,
              "isActive"=>1,
              "name"=>"Network Gateway Appliance (10 Gbps)",
              "subDescription"=>"Network Gateway Appliance (10 Gbps)",
              "unitSize"=>2
            },
            {
              "firstOrderStepId"=>1,
              "id"=>240,
              "isActive"=>1,
              "name"=>"'Codename: Prime' storage",
              "unitSize"=>1
            },
            {
              "firstOrderStepId"=>nil,
              "id"=>242,
              "isActive"=>1,
              "name"=>"POWER8 Servers",
              "unitSize"=>nil
            }
          ]
        end
      end
    end
  end
end