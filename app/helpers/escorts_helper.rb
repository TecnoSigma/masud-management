# frozen_string_literal: true

module EscortsHelper
  def escort_links
    Order::ALLOWED_STATUSES.to_a.inject([]) do |links, hash_key|
      links << link_to(
        I18n.t("partials.admin_menu.escort.#{hash_key.first}"),
        { controller: '/employee_panel/administrator_panel/dashboard/escorts',
          action: 'escorts', status: hash_key.first },
        class: 'nav-link'
      )
    end
                           .join
                           .html_safe
  end

  def show_reasons?(order_status)
    [Order::ALLOWED_STATUSES[:blocked], Order::ALLOWED_STATUSES[:cancelled]].include?(order_status)
  end
end
