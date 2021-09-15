$(document).ready(function(){
  $('#vehicle_license_plate').mask('AAA-9999', { placeholder: '___-____' });

  $('#vehicle_license_plate').change(function(){
    var licensePlate = $(this).val();

    $(this).val(licensePlate.toUpperCase());
  });
});
