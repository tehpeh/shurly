$(document).ready(function() {

  $("form#shurl").submit(function(event) {
    event.preventDefault();
    $("textarea#short").html(null);
    longs = $("textarea#long").val().split("\n");
    if (longs.length > 99) { alert("This may take a while, please be patient."); }
    $.each(longs, function(index,url) {
      $.ajax({
        type: 'POST',
        url: "/admin/shurls",
        data: form = {long: url},
        async: false,
        success: function(data) { 
          $("textarea#short").append(location.protocol + 
          "//" + location.host + "/" + data.shurl.short + "\n");
        },
        error: function(response) { 
          $("textarea#short").append(response.responseText + "\n"); 
        }
      });
    });
  });

  $('#shurl-list').dataTable({
    "bStateSave": true,
    "bFilter": false,
    "bSort": false,
    "bProcessing": true,
    "sPaginationType": "full_numbers",
    "sAjaxSource": "/admin/shurls?format=datatables",
    "aoColumnDefs": [
      { "sWidth": "50%", "aTargets": [ "long" ] },
      { "sWidth": "15%", "aTargets": [ "request-count"] }
    ]
  });
});