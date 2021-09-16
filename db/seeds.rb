Status.create([
  { name: 'ativo' },
  { name: 'desativado' },
  { name: 'pendente' },
  { name: 'aceito' },
  { name: 'recusado' }
])

if Rails.env.development?
  Customer.create(email: 'joao.barros@barros.com.br',
                  password: '123456',
                  status: Status.find_by_name('ativo'))

  Team.create([
    { name: 'A' },
    { name: 'B' }
  ])
end
