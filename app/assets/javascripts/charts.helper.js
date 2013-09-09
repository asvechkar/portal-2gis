jQuery(function () {

  var options = {
    lines: {
      show: true
    },
    points: {
      show: true
    },
    xaxis: {
      tickDecimals: 0,
      tickSize: 1
    }
  };

  var today = new Date();
  jQuery.ajax({
    url:"/portal/get_incomes_by_month/9",
    type: "GET"
  })
    .done(function() { console.log("success"); })
    .fail(function() { console.log("error"); })
    .always(function() { console.log("complete"); });
  /*
    .done(function(data) {
      console.log(data);
      jQuery.plot("#chart-incomes", data, options);
    });
  */
});
