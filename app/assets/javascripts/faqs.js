$(document).ready(function() {
  $('.faq-answer').hide();

  $('.reveal-btn').click(function() {
    var id = $(this).data('id');
    $('.faq-answer').hide();
    $("#faq-answer-" + id).fadeIn(500);
  });
});
