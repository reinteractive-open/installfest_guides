module Fog
  module Compute
    class ProfitBricks
      class Image < Fog::Models::ProfitBricks::Base
        identity  :id,             :aliases => "imageId"

        attribute :name,           :aliases => "imageName"
        attribute :type,           :aliases => "imageType"
        attribute :size,           :aliases => "imageSize"
        attribute :cpu_hotplug,    :aliases => "cpuHotPlug"
        attribute :cpu_hotunplug,  :aliases => "cpuHotUnplug"
        attribute :ram_hotplug,    :aliases => "memoryHotPlug"
        attribute :ram_hotunplug,  :aliases => "memoryHotUnPlug"
        attribute :disc_hotplug,   :aliases => "discVirtioHotPlug"
        attribute :disc_hotunplug, :aliases => "discVirtioUnHotPlug"
        attribute :nic_hotplug,    :aliases => "nicHotPlug"
        attribute :nic_hotunplug,  :aliases => "nicHotUnPlug"
        attribute :server_ids,     :aliases => "serverIds"
        attribute :os_type,        :aliases => "osType"
        attribute :region,         :aliases => "location"
        attribute :bootable
        attribute :writeable
        attribute :public
      end
    end
  end
end
