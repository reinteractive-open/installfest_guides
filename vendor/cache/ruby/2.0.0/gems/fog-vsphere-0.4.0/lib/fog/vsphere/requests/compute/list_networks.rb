module Fog
  module Compute
    class Vsphere
      class Real
        def list_networks(filters = { })
          datacenter_name = filters[:datacenter]
          # default to show all networks
          only_active = filters[:accessible] || false
          raw_networks(datacenter_name).map do |network|
            next if only_active and !network.summary.accessible
            network_attributes(network, datacenter_name)
          end.compact
        end

        def raw_networks(datacenter_name)
          find_raw_datacenter(datacenter_name).network
        end

        protected

        def network_attributes network, datacenter
          {
            :id            => managed_obj_id(network),
            :name          => network.name,
            :accessible    => network.summary.accessible,
            :datacenter    => datacenter,
            :virtualswitch => network.class.name == "DistributedVirtualPortgroup" ? network.config.distributedVirtualSwitch.name : nil
          }
        end
      end
      class Mock
        def list_networks(datacenter_name)
          self.data[:networks].values.select {|n| n['datacenter'] == datacenter_name[:datacenter]} or
            raise Fog::Compute::Vsphere::NotFound
        end
      end
    end
  end
end
