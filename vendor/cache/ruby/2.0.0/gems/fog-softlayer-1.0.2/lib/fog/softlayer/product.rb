#
# Author:: Celso Fernandes (<fernandes@zertico.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

require 'fog/softlayer/compute/shared'

module Fog
  module Softlayer
    class Product < Fog::Service
      class MissingRequiredParameter < Fog::Errors::Error; end

      # Client credentials
      requires :softlayer_username, :softlayer_api_key

      # Excon connection settings
      recognizes :softlayer_api_url
      recognizes :softlayer_default_domain


      model_path 'fog/softlayer/models/product'
      collection    :packages
      model         :package
      collection    :items
      model         :item

      request_path 'fog/softlayer/requests/product'
      request :get_package_item
      request :get_package_items
      request :get_packages
      request :place_order

      # The Mock Service allows you to run a fake instance of the Service
      # which makes no real connections.
      #
      #
      class Mock
        attr_accessor :default_domain
        include Fog::Softlayer::Slapi
        include Fog::Softlayer::Compute::Shared

        def initialize(args)
          @softlayer_domains = []
          super(args)
        end

      end

      ##
      # Makes real connections to Softlayer.
      #
      class Real
        attr_accessor :default_domain
        include Fog::Softlayer::Slapi
        include Fog::Softlayer::Compute::Shared

        # Sends the real request to the real SoftLayer service.
        #
        # @param [String] service
        #   ...ayer.com/rest/v3/Softlayer_Service_Name...
        # @param path [String]
        #   ...ayer.com/rest/v3/Softlayer_Service_Name/path.json
        # @param [Hash] options
        # @option options [Array<Hash>] :body
        #   HTTP request body parameters
        # @option options [String] :softlayer_api_url
        #   Override the default (or configured) API endpoint
        # @option options [String] :softlayer_username
        #   Email or user identifier for user based authentication
        # @option options [String] :softlayer_api_key
        #   Password for user based authentication
        # @return [Excon::Response]
        def request(service, path, options={})

          # default HTTP method to get if not passed
          http_method = options[:http_method] || :get
          # set the target base url
          @request_url = options[:softlayer_api_url] || Fog::Softlayer::SL_API_URL
          # tack on the username and password
          credentialize_url(@credentials[:username], @credentials[:api_key])
          # set the SoftLayer Service name
          set_sl_service(service)
          # set the request path (known as the "method" in SL docs)
          set_sl_path(path)
          # set the query params if any


          # build request params
          params = { :headers => user_agent_header }
          params[:headers]['Content-Type'] = 'application/json'
          params[:expects] = options[:expected] || [200,201]
          params[:body] = Fog::JSON.encode({:parameters => [ options[:body] ]}) unless options[:body].nil?
          params[:query] = options[:query] unless options[:query].nil?

          # initialize connection object
          @connection = Fog::Core::Connection.new(@request_url, false, params)

          # send it
          response = @connection.request(:method => http_method)

          # decode it
          response.body = Fog::JSON.decode(response.body)
          response
        end

        private

        def credentialize_url(username, apikey)
          @request_url = "https://#{username}:#{apikey}@#{@request_url}"
        end

        ##
        # Prepend "SoftLayer_" to the service name and Snake_Camel_Case the string before appending it to the @request_url.
        #
        # On DNS we have the service: SoftLayer_Dns_Domain_ResourceRecord
        # As it does NOT follow any pattern, you can specify
        # :dns_domain_resourceRecord
        # So set_sl_service will NOT change you service name case (just first letters), pay attention
        def set_sl_service(service)
          service = "SoftLayer_" << service.to_s.gsub(/^softlayer_/i, '').split('_').map{|i| i[0].upcase + i[1..-1]}.join('_')
          @request_url += "/#{service}"
        end

        ##
        # Try to smallCamelCase the path before appending it to the @request_url
        #
        def set_sl_path(path)
          path = path.to_s.softlayer_underscore.softlayer_camelize
          @request_url += "/#{path}.json"
        end

        def user_agent_header
          {"User-Agent" => "Fog SoftLayer Adapter #{Fog::Softlayer::VERSION}"}
        end

      end

    end

  end
end
