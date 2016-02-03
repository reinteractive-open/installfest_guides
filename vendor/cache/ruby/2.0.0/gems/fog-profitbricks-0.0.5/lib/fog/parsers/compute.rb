module Fog
  module Parsers
    module Compute
      module ProfitBricks
        autoload :Base, File.expand_path('../compute/profit_bricks/base', __FILE__)
        autoload :ClearDataCenter, File.expand_path('../compute/profit_bricks/clear_data_center', __FILE__)
        autoload :ConnectStorageToServer, File.expand_path('../compute/profit_bricks/connect_storage_to_server', __FILE__)
        autoload :CreateDataCenter, File.expand_path('../compute/profit_bricks/create_data_center', __FILE__)
        autoload :CreateNic, File.expand_path('../compute/profit_bricks/create_nic', __FILE__)
        autoload :CreateServer, File.expand_path('../compute/profit_bricks/create_server', __FILE__)
        autoload :CreateStorage, File.expand_path('../compute/profit_bricks/create_storage', __FILE__)
        autoload :DeleteDataCenter, File.expand_path('../compute/profit_bricks/delete_data_center', __FILE__)
        autoload :DeleteNic, File.expand_path('../compute/profit_bricks/delete_nic', __FILE__)
        autoload :DeleteServer, File.expand_path('../compute/profit_bricks/delete_server', __FILE__)
        autoload :DeleteStorage, File.expand_path('../compute/profit_bricks/DeleteStorage', __FILE__)
        autoload :DisconnectStorageFromServer, File.expand_path('../compute/profit_bricks/disconnect_storage_from_server', __FILE__)
        autoload :GetAllDataCenters, File.expand_path('../compute/profit_bricks/get_all_data_centers', __FILE__)
        autoload :GetAllImages, File.expand_path('../compute/profit_bricks/get_all_images', __FILE__)
        autoload :GetAllNic, File.expand_path('../compute/profit_bricks/get_all_nic', __FILE__)
        autoload :GetAllServers, File.expand_path('../compute/profit_bricks/get_all_servers', __FILE__)
        autoload :GetAllStorages, File.expand_path('../compute/profit_bricks/get_all_storages', __FILE__)
        autoload :GetDataCenter, File.expand_path('../compute/profit_bricks/get_data_center', __FILE__)
        autoload :GetDataCenterState, File.expand_path('../compute/profit_bricks/get_data_center_state', __FILE__)
        autoload :GetImage, File.expand_path('../compute/profit_bricks/get_image', __FILE__)
        autoload :GetNic, File.expand_path('../compute/profit_bricks/get_nic', __FILE__)
        autoload :GetServer, File.expand_path('../compute/profit_bricks/get_server', __FILE__)
        autoload :GetStorage, File.expand_path('../compute/profit_bricks/get_storage', __FILE__)
        autoload :ResetServer, File.expand_path('../compute/profit_bricks/reset_server', __FILE__)
        autoload :SetInternetAccess, File.expand_path('../compute/profit_bricks/set_internet_access', __FILE__)
        autoload :UpdateDataCenter, File.expand_path('../compute/profit_bricks/update_data_center', __FILE__)
        autoload :UpdateNic, File.expand_path('../compute/profit_bricks/update_nic', __FILE__)
        autoload :UpdateServer, File.expand_path('../compute/profit_bricks/update_server', __FILE__)
        autoload :UpdateStorage, File.expand_path('../compute/profit_bricks/update_storage', __FILE__)
      end
    end
  end
end
