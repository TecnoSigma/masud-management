Status.destroy_all
Status.create(name: 'ativo')
Status.create(name: 'desativado')
Status.create(name: 'pendente')
Status.create(name: 'agendado')
Status.create(name: 'confirmado')
Status.create(name: 'recusado')
Status.create(name: 'regular')
Status.create(name: 'irregular')
Status.create(name: 'cancelado pelo cliente')

# Create States and Cities
Tasks::PlacesGenerator.call!

# Create Customers
Tasks::CustomersGenerator.call!

# Create Agents
Tasks::AgentsGenerator.call!

# Create Vehicles
Tasks::VehiclesGenerator.call!

# Creates Tackles
Tasks::TacklesGenerator.call!

# Creates Arsenals
Tasks::ArsenalsGenerator.call!

if Rails.env.development?
  # Teams
  Team.create([{ name: 'A' }, { name: 'B' } ])

  # Employees
  FactoryBot.create(:employee, :admin)
  FactoryBot.create(:employee, :agent)
  FactoryBot.create(:employee, :lecturer)
  FactoryBot.create(:employee, :operator)

  # Customers
  FactoryBot.create(:customer, email: 'tecnooxossi@gmail.com', password: '123456', company: 'ACME')
  FactoryBot.create(:customer, email: 'xpto@xpto.com.br', password: '123456', company: 'XPTO')

  (1..40).each do |_a|
    sleep(2)

    FactoryBot.create(:order,
                      [:scheduled, :confirmed, :refused].sample,
                      customer: [Customer.find_by_email('tecnooxossi@gmail.com'),
                                 Customer.find_by_email('xpto@xpto.com.br')].sample)
  end
end
