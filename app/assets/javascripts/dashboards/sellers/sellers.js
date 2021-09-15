$(document).ready(function(){
  $('#seller_expedition_date').mask('00/00/0000', { placeholder: '__/__/____' });
  $('#seller_expiration_date').mask('00/00/0000', { placeholder: '__/__/____' });
  $('#seller_postal_code').mask('00000-000', { placeholder: '_____-___' });
  $('#seller_cellphone').mask('(00) 0 0000 0000', { placeholder: '(__) _ ____ ____' });
});
