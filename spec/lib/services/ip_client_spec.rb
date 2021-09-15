require 'rails_helper'

RSpec.describe Services::IpClient do
  describe '.ip' do
    it 'returns subscriber IP' do
      ip = '152.191.88.502'

      response = {"geoplugin_request"=>ip,
                  "geoplugin_status"=>200,
                  "geoplugin_delay"=>"1ms",
                  "geoplugin_credit"=>"Some of the returned data includes GeoLite data created by MaxMind, available from <a href='http://www.maxmind.com'>http://www.maxmind.com</a>.",
                  "geoplugin_city"=>"São Paulo",
                  "geoplugin_region"=>"Sao Paulo",
                  "geoplugin_regionCode"=>"SP",
                  "geoplugin_regionName"=>"Sao Paulo",
                  "geoplugin_areaCode"=>"",
                  "geoplugin_dmaCode"=>"",
                  "geoplugin_countryCode"=>"BR",
                  "geoplugin_countryName"=>"Brazil",
                  "geoplugin_inEU"=>0,
                  "geoplugin_euVATrate"=>false,
                  "geoplugin_continentCode"=>"SA",
                  "geoplugin_continentName"=>"South America",
                  "geoplugin_latitude"=>"-40.627",
                  "geoplugin_longitude"=>"-22.635",
                  "geoplugin_locationAccuracyRadius"=>"20",
                  "geoplugin_timezone"=>"America/Sao_Paulo",
                  "geoplugin_currencyCode"=>"BRL",
                  "geoplugin_currencySymbol"=>"R$",
                  "geoplugin_currencySymbol_UTF8"=>"R$",
                  "geoplugin_currencyConverter"=>3.8552}.to_json

      allow(RestClient).to receive(:get) { response }

      expect(described_class.ip).to eq(ip)
    end 

    it 'returns empty value when occurs some errors' do
      allow(RestClient).to receive(:get) { raise RestClient::NotFound }

      expect(described_class.ip).to be_empty
    end 
  end 
end

