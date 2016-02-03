require File.expand_path('../image', __FILE__)

module Fog
  module Compute
    class ProfitBricks
      class Images < Fog::Collection
        model Fog::Compute::ProfitBricks::Image

        def all
          load(service.get_all_images.body["getAllImagesResponse"])
        end

        def get(id)
          image = service.get_image(id).body["getImageResponse"]
          new(image)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
