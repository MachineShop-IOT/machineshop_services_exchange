$(document).ready(function() {
  $("a.delete-white-paper").bind("ajax:success", function(evt, data, status, xhr) {
    console.log(this)
    $(this).parents(".white-paper-listing").fadeOut(500);
  });
  $("a.delete-white-paper").bind("ajax:error", function(evt, xhr, status, error) {
    alert("We're sorry but something went wrong. The white paper was not deleted.")
  });
});

$(document).ready(function() {
  $("a.delete-faq").bind("ajax:success", function(evt, data, status, xhr) {
    $(this).parents(".faq-listing").fadeOut(500);
  });
  $("a.delete-faq").bind("ajax:error", function(evt, xhr, status, error) {
    alert("We're sorry but something went wrong. The question was not deleted.")
  });
});
