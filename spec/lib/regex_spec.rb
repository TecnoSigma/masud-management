require 'rails_helper'

RSpec.describe Regex do
  describe '.float' do
    it 'checks invalid float' do
      invalid_number = 'anything'

      expect(described_class.float).not_to match(invalid_number)
    end
  end

  describe '.license_plate' do
    it 'checks valid license plate' do
      license_plate = 'ABC-1234'

      expect(described_class.license_plate).to match(license_plate)
    end

    it 'checks valid Mercosul license plate' do
      license_plate = 'ABC 1C34'

      expect(described_class.license_plate).to match(license_plate)
    end

    it 'checks invalid license plate' do
      license_plate = 'ABC-12i'
       
      expect(described_class.license_plate).not_to match(license_plate) 
    end
  end

  describe '.linkedin_url' do
    it 'checks valid LinkedIn URL' do
      linkedin_url = 'https://www.linkedin.com/in/thiago-munizo-727036175'

      expect(described_class.linkedin_url).to match(linkedin_url)
    end

    it 'checks invalid LinkedIn URL' do
      linkedin_url = 'anything'

      expect(described_class.linkedin_url).not_to match(linkedin_url)
    end
  end

  describe '.cpf' do
    it 'checks valid CPF' do
      cpf = '123.456.789-00'

      expect(described_class.cpf).to match(cpf)
    end

    it 'checks invalid CPF' do
      cpf = '123.456.789'

      expect(described_class.cpf).not_to match(cpf)
    end
  end

  describe '.core_register' do
    it 'checks valid CORE register' do
      core_register = '1234567/2019'

      expect(described_class.core_register).to match(core_register)
    end

    it 'checks invalid CORE register' do
      core_register = '123'

      expect(described_class.core_register).not_to match(core_register)
    end
  end

  describe '.driver_license' do
    it 'checks valid driver license' do
      driver_license = '12.345.678.900'

      expect(described_class.driver_license).to match(driver_license)
    end

    it 'checks invalid driver license' do
      driver_license = 'ABCDE123456'

      expect(described_class.driver_license).not_to match(driver_license)
    end
  end

  describe '.kind' do
    it 'checks valid kind is a PF' do
      kind = 'PF'

      expect(described_class.kind).to match(kind)
    end 

    it 'checks valid kind is a PJ' do
      kind = 'PJ'

      expect(described_class.kind).to match(kind)
    end 

    it 'checks invalid kind' do
      kind = 'anything'

      expect(described_class.kind).not_to match(kind)
    end
  end 

  describe '.document' do
    it 'checks valid document' do
      cpf = '123.456.789-00'
      cnpj = '12.345.677/0001-33'

      expect(described_class.document).to match(cpf)
      expect(described_class.document).to match(cnpj)
    end

    it 'checks invalid document' do
      cpf = '123.456.789'
      cnpj = '12.345.677/00000-11'

      expect(described_class.document).not_to match(cpf)
      expect(described_class.document).not_to match(cnpj)
    end
  end

    describe '.email' do
    it 'checks valid email' do
      email = 'abc@teste.com.br'

      expect(described_class.email).to match(email)
    end

    it 'checks invalid email' do
      email = 'abc@@'

      expect(described_class.email).not_to match(email)
    end
  end

  describe '.postal_code' do
    it 'checks valid postal code' do
      postal_code = '05612-000'

      expect(described_class.postal_code).to match(postal_code)
    end

    it 'checks invalid postal code' do
      postal_code = '03331abc'

      expect(described_class.postal_code).not_to match(postal_code)
    end
  end

  describe '.password' do
    it 'checks valid password' do
      password = 'abcABCabc999'

      expect(described_class.password).to match(password)
    end

    it 'checks invalid password' do
      password = 'abc123s'

      expect(described_class.password).not_to match(password)
    end
  end

  describe '.user' do
    it 'checks valid user' do
      user = 'abcABCabc'

      expect(described_class.user).to match(user)
    end

    it 'checks invalid user' do
      user = 'abc'

      expect(described_class.user).not_to match(user)
    end
  end

  describe '.telephone' do
    it 'checks valid telephone' do
      telephone = '(11) 1234 8888'

      expect(described_class.telephone).to match(telephone)
    end

    it 'checks invalid telephone' do
      telephone = '1234 8888'

      expect(described_class.telephone).not_to match(telephone)
    end
  end

  describe '.cellphone' do
    it 'checks valid cellphone' do
      cellphone = '(11) 9 1234 8888'

      expect(described_class.cellphone).to match(cellphone)
    end

    it 'checks invalid cellphone' do
      cellphone = '1234 8888'

      expect(described_class.cellphone).not_to match(cellphone)
    end
  end
end
