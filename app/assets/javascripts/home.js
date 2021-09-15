$(document).ready(function(){
  initializers();

  renderViolenceChart();

  $("#company_lnk").on('click', function(event) {
    scrollToSession(this);
  });

  $("#benefits_lnk").on('click', function(event) {
    scrollToSession(this);
  });

  $("#subscribe_now_lnk").on('click', function(event) {
    scrollToSession(this);
  });

  $("#jobs_link").on('click', function(event) {
    scrollToSession(this);
  });
});

function scrollToSession(link) {
  if (link.hash !== "") {
    event.preventDefault();

    var hash = link.hash;

    $('html, body').animate({
      scrollTop: $(hash).offset().top
    }, 800, function(){
      window.location.hash = hash;
    });
  }
}

function renderViolenceChart() {
  $.ajax({
    type: 'GET',
    url: '/home/chart_data',
    data: { },
    success: function(data, status, xhr){
      var ctx = document.getElementById('violence_chart').getContext('2d');
      var chartData = data['violence_data']
      var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: [chartData[0]['month'],
                   chartData[1]['month'],
                   chartData[2]['month'],
                   chartData[3]['month'],
                   chartData[4]['month'],
                   chartData[5]['month'],
                   chartData[6]['month'],
                   chartData[7]['month'],
                   chartData[8]['month']],
          datasets: [{
            label: data['legend'],
            data: [chartData[0]['death'],
                   chartData[1]['death'],
                   chartData[2]['death'],
                   chartData[3]['death'],
                   chartData[4]['death'],
                   chartData[5]['death'],
                   chartData[6]['death'],
                   chartData[7]['death'],
                   chartData[8]['death']],
            backgroundColor: 'rgba(255, 0, 0, 0.4)',
            borderColor: 'rgba(255, 0, 0, 1)',
            borderWidth: 1
          }]
        },
        options: {
          title: {
            display: true,
            fontSize: 30,
            text: [data['title'], data['subtitle']]
          }
        }
      });
    },
    error: function(xhr,status,error){
      console.log(xhr);
    }
  });
}

function initializers() {
  $('#new_seller_document').mask('000.000.000-00', { placeholder: '___.___.___-__'});
  $('#new_seller_core_register').mask('0000000/0000', { placeholder: '_______/____'});
  $('#new_seller_expedition_date').mask('00/00/0000', { placeholder: '__/__/____'});
  $('#new_seller_expiration_date').mask('00/00/0000', { placeholder: '__/__/____'});
  $('#new_seller_postal_code').mask('00000-000', { placeholder: '_____-___'});
  $('#new_seller_cellphone').mask('(00) 0 0000 0000', { placeholder: '(__) _ ____ ____'});
}
