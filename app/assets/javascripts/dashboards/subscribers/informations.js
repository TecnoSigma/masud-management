$(document).ready(function(){
  $('#edit_subscriber_postal_code').mask('00000-000', { placeholder: '_____-___' });
  $('#edit_subscriber_telephone').mask('(00) 0000 0000', { placeholder: '(__) ____ ____' });
  $('#edit_subscriber_cellphone').mask('(00) 0 0000 0000', { placeholder: '(__) _ ____ ____' });
});
