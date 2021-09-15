module Regex
  class << self
    def driver_license
      /\A\d{2}.\d{3}.\d{3}.\d{3}\z/
    end

    def license_plate
      /\A([A-Z]{3} [0-9]{1}[A-Z]{1}[0-9]{2}|[A-Z]{3}-\d{4})\z/
    end

    def kind
      /\A(PF|PJ)\z/
    end

    def document
      /\A^([0-9]{3}\.?[0-9]{3}\.?[0-9]{3}\-?[0-9]{2}|[0-9]{2}\.?[0-9]{3}\.?[0-9]{3}\/?[0-9]{4}\-?[0-9]{2})$\z/    
    end

    def core_register
      /\A\d{7}\/\d{4}\z/
    end

    def cpf
      /\A\d{3}.\d{3}.\d{3}-\d{2}\z/
    end

    def email
     /\A[a-z0-9._-]+@[a-z0-9]+.[a-z0-9.]+.[a-z0-9._-]*\z/
    end

    def postal_code
      /\A\d{5}-\d{3}\z/
    end

    def telephone
      /\A\([1-9]{2}\) [0-9]{4}\ [0-9]{4}\z/
    end

    def cellphone
      /\A\([1-9]{2}\) 9 [0-9]{4}\ [0-9]{4}\z/
    end

    def password
      /\A[a-zA-Z0-9]{10,20}\z/
    end

    def user
      /\A[a-zA-Z0-9]{6,12}\z/
    end

    def float
      /\A\d*\.\d+\z/
    end

    def linkedin_url
      /\Ahttps:\/\/[a-z]{0,3}.*\linkedin\.com\/.*\z/
    end
  end
end

