require 'rest-client'

Heartcheck.setup do |config|
  config.add :activerecord do |c|
    c.register_dynamic_services do
      [{name: 'activerecord', connection: ActiveRecord::Base.connection}]
    end
  end

  config.add :base do |c|
    c.name = 'ip-client'
    c.functional = false

    c.to_validate do |services, errors|
      begin
        Services::IpClient.ip
      rescue Exception => e
        errors << "Failed connection to collect IP (client-side)! #{e.message}"
      end
    end
  end

  config.add :base do |c| 
    c.name = 'payment-gateway'
    c.functional = false

    c.to_validate do |services, errors|
      begin
        Moip::Assinaturas::Customer.list
      rescue Exception => e
        errors << "Failed connection with MOIP gateway! #{e.message}"
      end 
    end 
  end
end

