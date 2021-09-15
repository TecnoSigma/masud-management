$(document).ready(function(){
  $('#new_subscriber_responsible_cpf').mask('000.000.000-00',{ placeholder: '___.___.___-__' });
  $('#new_subscriber_document').mask('00.000.000/0000-00', { placeholder: '__.___.___./____-__' });
  $('#new_subscriber_postal_code').mask('00000-000', { placeholder: '_____-___' });
  $('#new_subscriber_telephone').mask('(00) 0000 0000', { placeholder: '(__) ____ ____' });
  $('#new_subscriber_cellphone').mask('(00) 0 0000 0000', { placeholder: '(__) _ ____ ____' });
  $('#seller_document').mask('000.000.000-00',{ placeholder: '___.___.___-__' });
  $('#password_seller_document').mask('000.000.000-00',{ placeholder: '___.___.___-__' });

  initializers();

  $('#new_subscriber_kind_pj').click(function(){
    showResponsibleInfo();
    changeDocumentMask();
  });

  $('#subscriber_kind_pf').click(function(){
    hideResponsibleInfo();
    changeDocumentMask();
  });

  $('#new_subscriber_user').focus(function(){
    $('#new_subscriber_password').attr('disabled', 'disabled');
    $('#new_subscriber_confirm_password').attr('disabled', 'disabled');
  });

  $('#new_subscriber_user').blur(function(){
    $.ajax({
      type: 'GET',
      url: '/checkout/user_availability',
      data: { user: $(this).val() },
      success: function(data,status,xhr){
        if (data.available){
          $('#available_user').removeClass('hidden-messages');
          $('#unavailable_user').addClass('hidden-messages');

          $('#new_subscriber_password').removeAttr('disabled');
          $('#new_subscriber_confirm_password').removeAttr('disabled');
        }else{
          $('#available_user').addClass('hidden-messages');
          $('#unavailable_user').removeClass('hidden-messages');

          $('#new_subscriber_password').focus();
        }
      },
      error: function(xhr,status,error){
        console.log(xhr);
      }
    });
  });

  $('#new_subscriber_postal_code').bind('input propertychange', function(){
    if ($(this).val().length == 9) {
      $.ajax({
        type: 'GET',
        url: '/checkout/subscriber_address',
        data: { postal_code: $(this).val() },
        success: function(data,status,xhr){
          $('#new_subscriber_address').val(data.address);
          $('#new_subscriber_district').val(data.neighborhood);
          $('#new_subscriber_city').val(data.city);
          $('#new_subscriber_state').val(data.state);
        },
        error: function(xhr,status,error){
          console.log(xhr);
        }
      });
    }
  });

  $('#payment_payment_method').change(function(){
    if ($('#payment_payment_method').val() == 'Cartão de Crédito') {
      $("#payment_with_credit_card").fadeIn('slow');
      $("#payment_with_ticket").fadeOut('slow');

      $("#payment_credit_card_number").prop('required', true);
      $("#payment_expiration_month").prop('required', true);
      $("#payment_expiration_year").prop('required', true);
      $("#payment_holder_name").prop('required', true);

      $('#finish_buy_btn').attr('disabled', 'disabled');
    }

    if ($('#payment_payment_method').val() == 'Boleto') {
      $("#payment_with_credit_card").fadeOut();
      $("#payment_with_ticket").fadeIn('3000');

      $("#payment_credit_card_number").prop('required', false);
      $("#payment_expiration_month").prop('required', false);
      $("#payment_expiration_year").prop('required', false);
      $("#payment_holder_name").prop('required', false);

      $('#finish_buy_btn').removeAttr('disabled');
    }
  });

  $("#payment_holder_name").blur(function() {
    var holder_name = $(this).val();

    $(this).val(holder_name.toUpperCase());

    enableDisableFinishBuyBtn();
  });

  $('#new_subscriber_email').blur(function(){
    if (validateEmail($(this).val())) {
      $('#invalid_email_message').addClass('hidden-messages');
    } else {
      $('#invalid_email_message').removeClass('hidden-messages');
      $('#new_subscriber_email').val('');
      $('#new_subscriber_email').focus();
    }
  });

  $('#payment_credit_card_number').bind('input propertychange', function() {
      
  });

  $('#new_subscriber_password').bind('input propertychange', function() {
    var employee = $('#new_subscriber_user').val();
    var password = $(this).val();
    var strength = PasswordStrength.test(employee, password);

    if (strength.isGood() || strength.isStrong()) {
      $('#fragile_password').addClass('hidden-messages');
      $('#strong_password').removeClass('hidden-messages');

      $('#new_subscriber_confirm_password').removeAttr('disabled');
    } else {
      $('#fragile_password').removeClass('hidden-messages');
      $('#strong_password').addClass('hidden-messages');

      $('#new_subscriber_confirm_password').attr('disabled', 'disabled');
    }
  });

  $('#new_subscriber_password').focus(function(){
    $(this).val('');
    $('#new_subscriber_confirm_password').val('');
  });

  $('#new_subscriber_confirm_password').bind('input propertychange', function() {
    if ($(this).val() == $('#subscriber_password').val()) {
      $('#next_step_vehicle_to_new_subscriber_btn').removeAttr('disabled');
    } else {
      $('#next_step_vehicle_to_new_subscriber_btn').attr('disabled', 'disabled');
    }
  });

  $('#vehicle_brand').bind('input propertychange', function(){
    $.ajax({
      type: 'GET',
      dataType: 'json',
      url: '/checkout/vehicle_model_list',
      data: { vehicle_brand: $(this).val() },
      success: function(response){
        var models = $('#vehicle_kind');

        models.empty();

        $.each(response, function(i, val) {
          models.append($('<option></option>').val(val).html(val));
        });

        models.focus();
      },
      error: function(xhr,status,error){
        console.log(xhr);
      }   
    });
  });

  $('#vehicle_license_plate').blur(function(){
    var license_plate = $(this).val();

    $(this).val(license_plate.toUpperCase());
  });

  $('#vehicle_mercosul_false').click(function(){
    changeToDefaultLicensePlateMask();

    $('#vehicle_license_plate').val('');
  });
  
  $('#vehicle_mercosul_true').click(function(){
    changeToMercosulLicensePlateMask();

    $('#vehicle_license_plate').val('');
  });
});

function initializers() {
  maskFields();
  changeDocumentMask();
  getSubscriberIp();
  showCreditCardPaymentMethod();
  enableDisableFinishBuyBtn();

  $('#next_step_vehicle_to_new_subscriber_btn').attr('disabled', 'disabled');
  $('#new_subscriber_password').attr('disabled', 'disabled');
  $('#new_subscriber_confirm_password').attr('disabled', 'disabled');
}

function getSubscriberIp() {
  $.ajax({
    type: 'GET',
    url: '/checkout/subscriber_ip',
    success: function(data,status,xhr){
      $('#new_subscriber_ip').val(data.ip);
    },
    error: function(xhr,status,error){
      console.log(xhr);
    }
  });
}

function validateEmail(email) {
  if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
    return true;
  }
  return false;
};

function changeToDefaultLicensePlateMask() {
  $('#vehicle_license_plate').mask('AAA-0000',
                                   { placeholder: '___-____' });
}

function changeToMercosulLicensePlateMask() {
  $('#vehicle_license_plate').mask('AAA 0A00',
                                   { placeholder: '___ ____' });
}

function showResponsibleInfo() {
  $('#responsible-info').fadeIn();

  document.getElementById("name_lbl").innerHTML = 'Empresa';
  document.getElementById("doc_lbl").innerHTML = 'CNPJ';
}

function hideResponsibleInfo() {
  $('#responsible-info').fadeOut();

  document.getElementById("name_lbl").innerHTML = 'Nome';
  document.getElementById("doc_lbl").innerHTML = 'CPF';
}

function maskFields() {
  $('#new_subscriber_telephone').mask('(00) 0000 0000',
                                      { placeholder: '(__) ____ ____' });
  $('#new_subscriber_cellphone').mask('(00) 0 0000 0000',
                                      { placeholder: '(__) _ ____ ____' });
  $('#new_subscriber_postal_code').mask('00000-000',
                                        { placeholder: '_____-___' });
  $('#new_subscriber_responsible_cpf').mask('000.000.000-00',
                                            { placeholder: '___.___.___-__' });
  $('#payment_credit_card_number').mask('0000 0000 0000 0000',
                                        { placeholder: '____ ____ ____ ____' });
  $('#seller_cpf').mask('000.000.000-00',
                        { placeholder: '___.___.___-__' });

  changeToDefaultLicensePlateMask();
}

function changeDocumentMask() {
  $('#new_subscriber_document').val('');

  if ($('#new_subscriber_kind_pj').is(':checked')){
    $('#new_subscriber_document').mask('00.000.000/0000-00',
                                   { placeholder: '__.___.___./____-__' });
  } else {
    $('#new_subscriber_document').mask('000.000.000-00',
                                   { placeholder: '___.___.___-__' });
  }
}

function showCreditCardPaymentMethod() {
  $("#payment_with_credit_card").fadeIn('slow');
  $("#payment_with_ticket").fadeOut();
}

function enableDisableFinishBuyBtn() {
  if (($('#payment_credit_card_number').val() == '') || ($('#payment_holder_name').val() == '')) {
    $('#finish_buy_btn').attr('disabled', 'disabled');
  } else {
    $('#finish_buy_btn').removeAttr('disabled');
  }
}
