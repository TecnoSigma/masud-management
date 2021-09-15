$(document).ready(function() {
  $('#login_document').mask('000.000.000-00', { placeholder: '___.___.___-__' });

  $('#external-circle-on').mouseover(function(){
    $(this).css({ "background-color": "#fff",
                  "-webkit-box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)",
                  "-moz-box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)",
                  "box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)" });

    $('#internal-square-on').css({ "background-color": "#fff",
                                   "-webkit-box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)",
                                   "-moz-box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)",
                                   "box-shadow": "10px 10px 170px 20px rgba(255,255,255,0.5)" });
  });

  $('#external-circle-on').mouseout(function(){
    $(this).css({ "background-color": "#00ff00",
                  "-webkit-box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)",
                  "-moz-box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)",
                  "box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)" }); 

    $('#internal-square-on').css({ "background-color": "#00ff00",
                                   "-webkit-box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)",
                                   "-moz-box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)",
                                   "box-shadow": "10px 10px 170px 20px rgba(0,255,0,0.5)" });
  });


  $('#login_document').blur(function(){
    const documentLength = 14

    if($(this).val().length == documentLength) {
      $.ajax({
        type: 'GET',
        dataType: 'json',
        url: '/angels/active_subscriber_list',
        data: { angel_document: $(this).val() },
        success: function(response){
          var protecteds = $('#login_protected_code');

          protecteds.empty();

          $.each(response, function(i, val) {
            protecteds.append($('<option></option>').val(val[0]).html(val[1]));
          });

          protecteds.focus();
        },  
        error: function(xhr,status,error){
          console.log(xhr);
        }
      });
    }
  });
});
