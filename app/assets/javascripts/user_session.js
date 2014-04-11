$(document).ready(function() {
  window.addEventListener("orientationchange", function() {
    var navHeight = parseInt($('#login-nav').css('height'));
    var pageHeight = parseInt($('body').css('height'));
    $('#content-login').css('height', pageHeight - navHeight);
  }, false);

  var navHeight = parseInt($('.row-fluid#login-nav').css('height'));
  var pageHeight = parseInt($('body').css('height'));
  $('#content-login').css('height', pageHeight - navHeight);
});
