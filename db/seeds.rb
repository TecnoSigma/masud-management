Status.create([
  { name: 'ativo' },
  { name: 'desativado' },
  { name: 'pendente' },
  { name: 'aceito' },
  { name: 'recusado' },
  { name: 'regular' },
  { name: 'irregular' }
])

Profile.create([
  { name: 'Adminstrador', kind: 'administrator' },
  { name: 'Agente', kind: 'agent' },
  { name: 'Aprovador', kind: 'approver' },
  { name: 'Conferente', kind: 'lecturer' },
  { name: 'Operador', kind: 'operator' }
])

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

if Rails.env.development?
  # Teams
  Team.create([{ name: 'A' }, { name: 'B' } ])

  # Employees
  FactoryBot.create(:employee, :admin)
  FactoryBot.create(:employee, :agent)
  FactoryBot.create(:employee, :lecturer)
  FactoryBot.create(:employee, :operator)

  # Customers
  FactoryBot.create(:customer, email: 'acme@acme.com.br', password: '123456', company: 'ACME')
end
