class Status
  STATUSES = { activated: I18n.t('statuses.activated'),
               pendent: I18n.t('statuses.pendent'),
               deactivated: I18n.t('statuses.deactivated'),
               cancelled_by_subscriber: I18n.t('statuses.cancelled_by_subscriber'),
               cancelled_by_company: I18n.t('statuses.cancelled_by_company'),
               deleted: I18n.t('statuses.deleted') }

  VEHICLE_STATUSES = { activated: I18n.t('statuses.activated'),
                       without_photos: I18n.t('statuses.without_photos')}

  PAYMENT_STATUSES = { activated: 'ACTIVE',
                       deactivated: 'SUSPENDED' }.freeze

  TICKET_STATUSES = { opened: I18n.t('statuses.opened'),
                      in_treatment: I18n.t('statuses.in_treatment'),
                      waiting_subscriber: I18n.t('statuses.waiting_subscriber'),
                      waiting_company: I18n.t('statuses.waiting_company'),
                      finished: I18n.t('statuses.finished'),
                      closed: I18n.t('statuses.closed'),
                      recurrence: I18n.t('statuses.recurrence') }.freeze

  ORDER_STATUSES = { pendent: I18n.t('statuses.pendent'),
                     approved: I18n.t('statuses.approved'),
                     refused: I18n.t('statuses.refused') }.freeze
end
