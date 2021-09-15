module Dashboards::RegisterHelper
  def translated_profile(kind)
    kind == Subscriber::COMPANY ? 'Pessoa Jurídica' : 'Pessoa Física'
  end
end
