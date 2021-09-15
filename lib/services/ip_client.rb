module Services
  class IpClient
    IP_PLUGIN_URL = 'http://www.geoplugin.net/json.gp'

    class << self
      def ip
        response = RestClient.get(IP_PLUGIN_URL)

        JSON.parse(response)['geoplugin_request']
      rescue RestClient::NotFound
        ''
      end
    end
  end
end

