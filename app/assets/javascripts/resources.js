$(document).ready(function(){
  $(document).on('change', '.api-docs-library-select', function() {
    var option = $('>', this).children('option:selected');
    $('.document, .edit-document').hide();
    $("#document-" + ($(option).data('id'))).show();
  });
});
