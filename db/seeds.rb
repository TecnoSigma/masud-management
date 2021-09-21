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
  Customer.create(email: 'joao.barros@barros.com.br',
                  password: '123456',
                  status: Status.find_by_name('ativo'))

  Employee.create(email: 'admin@admin.com.br',
                  profiles: [Profile.find_by_name('Adminstrador')],
                  password: '123456',
                  status: Status.find_by_name('ativo'))

  Employee.create(email: 'agent@agent.com.br',
                   profiles: [Profile.find_by_name('Agente')],
                   password: '123456',
                   status: Status.find_by_name('ativo'))

  Employee.create(email: 'approver@approver.com.br',
                   profiles: [Profile.find_by_name('Aprovador')],
                   password: '123456',
                   status: Status.find_by_name('ativo'))

  Employee.create(email: 'lecturer@lecturer.com.br',
                   profiles: [Profile.find_by_name('Conferente')],
                   password: '123456',
                   status: Status.find_by_name('ativo'))

  Employee.create(email: 'operator@operator.com.br',
                   profiles: [Profile.find_by_name('Operador')],
                   password: '123456',
                   status: Status.find_by_name('ativo'))

  Team.create([
    { name: 'A' },
    { name: 'B' }
  ])
end
