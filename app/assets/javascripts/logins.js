$(document).ready(function(){
  $('#angel_document').mask('000.000.000-00', { placeholder: '___.___.___-__' });
  $('#driver_license').mask('00.000.000.000', { placeholder: '__.___.___.___' });

  $('#license_plate').blur(function(){
    var license = $(this).val();

    $(this).val(license.toUpperCase());
  });

  $('#angel_document').bind('input propertychange', function(){
    if ($(this).val().length == 14) {
      $.ajax({           
        type: 'GET',
        url: '/cameras/logins/driver_names',
        data: { angel_document: $(this).val() },
        success: function(response){
          var driverNames = $('#driver_names');

          driverNames.empty();

          $.each(response, function(i, val) {
            driverNames.append($('<option></option>').val(val[0]).html(val[1]));
          });

          driverNames.focus();
        },
        error: function(xhr,status,error){
          console.log(xhr);
        }
      });
    }
  }); 
});
