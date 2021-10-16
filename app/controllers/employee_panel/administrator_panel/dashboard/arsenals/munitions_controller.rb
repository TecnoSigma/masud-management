# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      module Arsenals
        class MunitionsController < ArsenalsController
          before_action { check_internal_profile(params['controller']) }

          def list
            @munitions = Munition.all
          end
        end
      end
    end
  end
end
