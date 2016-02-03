module Fog
  module Compute
    class Voxel
      class Real
        def images_list(image_id = nil)
          options = {
            :parser     => Fog::Parsers::Compute::Voxel::ImagesList.new,
            :verbosity  => "compact"
          }

          unless image_id.nil?
            options[:verbosity] = "extended"
            options[:image_id] = image_id
          end

          data = request("voxel.images.list", options)

          if data.body["stat"] == "ok"
            data
          else
            raise Fog::Compute::Voxel::NotFound
          end
        end
      end
    end
  end
end
