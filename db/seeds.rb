Status.create([
  { name: 'ativo' },
  { name: 'desativado' },
  { name: 'pendente' },
  { name: 'aceito' },
  { name: 'recusado' }
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

# Create Agents
Tasks::AgentsGenerator.call!

if Rails.env.development?
  # Teams
  Team.create([{ name: 'A' }, { name: 'B' } ])

  # Employees
  FactoryBot.create(:employee, :admin)
  FactoryBot.create(:employee, :agent)
  FactoryBot.create(:employee, :lecturer)
  FactoryBot.create(:employee, :operator)

  # Customers
  Customer.create(email: 'joao.barros@barros.com.br',
                  password: '123456',
                  status: Status.find_by_name('ativo'))
end
