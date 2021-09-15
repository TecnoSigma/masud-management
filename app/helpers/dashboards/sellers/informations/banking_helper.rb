module Dashboards::Sellers::Informations::BankingHelper
  def bank_list
    Bank.all.map { |bank| ["#{bank.compe_register} - #{bank.name}", bank.compe_register] }
  end
end
