module CheckoutHelper
  def information_rule(step)
    case step
    when Hiring::STEPS[:identification]
      identification_marker
    when Hiring::STEPS[:vehicles]
      vehicles_marker
    when Hiring::STEPS[:resume]
      resume_marker
    when Hiring::STEPS[:payment]
      payment_marker
    when Hiring::STEPS[:finalization]
      finalization_marker
    end
  end

  def identification_marker
    "<li class='activated-step'><span>#{t('partials.information_rule.identification')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.vehicles')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.resume')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.payment')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.finalization')}</span></li>"
    .html_safe
  end

  def vehicles_marker
    "<li class='deactivated-step'><span>#{t('partials.information_rule.identification')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='activated-step'><span>#{t('partials.information_rule.vehicles')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.resume')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.payment')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.finalization')}</span></li>"
    .html_safe
  end

  def resume_marker
    "<li class='deactivated-step'><span>#{t('partials.information_rule.identification')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.vehicles')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='activated-step'><span>#{t('partials.information_rule.resume')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.payment')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.finalization')}</span></li>"
    .html_safe
  end

  def payment_marker
    "<li class='deactivated-step'><span>#{t('partials.information_rule.identification')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.vehicles')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.resume')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='activated-step'><span>#{t('partials.information_rule.payment')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.finalization')}</span></li>"
    .html_safe
  end

  def finalization_marker
    "<li class='deactivated-step'><span>#{t('partials.information_rule.identification')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.vehicles')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.resume')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='deactivated-step'><span>#{t('partials.information_rule.payment')}</span></li>" \
    "<li><i class='material-icons arrow'>label_important</i></li>" \
    "<li class='activated-step'><span>#{t('partials.information_rule.finalization')}</span></li>"
    .html_safe
  end

  def total_price(vehicles_amount, price, freight)
    total = (vehicles_amount.to_f * price.to_f) + freight.to_f
    
    convert_float_to_currency(total)
  end

  def subtotal(vehicles_amount, price)
    subtotal = vehicles_amount.to_f * price.to_f

    convert_float_to_currency(subtotal)
  end

  def payment_method_list
    Plan::ALLOWED_PAYMENT_METHODS.sort
  end

  def required?(vehicle_list)
    vehicle_list.empty?
  end
end

