# frozen_string_literal: true

module EmployeePanel
  module AdministratorPanel
    module Dashboard
      class ReportsController < EmployeePanelController
        before_action { check_internal_profile(params['controller']) }

        def escorts
          @escorts = Order
                     .where(type: 'EscortService')
                     .or(Order.where(type: 'EscortScheduling'))
                     .order(:order_number)

          respond_to do |format|
            type = Escort.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def customers
          @customers = Customer.all.order(:company)

          respond_to do |format|
            type = Customer.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def guns
          @guns = Gun.all.order(:kind)

          respond_to do |format|
            type = Gun.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def munitions
          @munitions = MunitionStock.all

          respond_to do |format|
            format.pdf { render_report('munitions', t('general_reports.types.munitions')) }
          end
        end

        def tackles
          @tackles = Tackle.all.order(:type)

          respond_to do |format|
            type = Tackle.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def employees
          @employees = Employee.all.order(:name)

          respond_to do |format|
            type = Employee.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def vehicles
          @vehicles = Vehicle.all.order(:name, :license_plate)

          respond_to do |format|
            type = Vehicle.to_s.pluralize.downcase

            format.pdf { render_report(type, t("general_reports.types.#{type}")) }
          end
        end

        def render_report(route, type)
          render template: "employee_panel/administrator_panel/dashboard/reports/#{route}",
                 pdf: t('general_reports.title', type: type),
                 footer: { right: '[page] de [topage]' }
        end
      end
    end
  end
end
