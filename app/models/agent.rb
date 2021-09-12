class Agent < Employee
  has_many :arsenals
  has_many :clothes
  belongs_to :team
end
