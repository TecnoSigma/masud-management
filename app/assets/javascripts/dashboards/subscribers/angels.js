$(document).ready(function(){
  initializers();
});

function initializers() {
  maskFields();
}

function maskFields() {
  $('#angel_cpf').mask('000.000.000-00',
                                        { placeholder: '___.___.___-__' });
}
