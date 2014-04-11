$(document).ready(function() {
  $(document).on('change', '#customer_role', function() {
    if ($('#customer_role option:selected').text() == 'Publisher') {
      $('#logo-upload').show();
    }
    else $('#logo-upload').hide();
  });
});