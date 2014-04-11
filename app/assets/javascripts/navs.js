$(document).ready(function() {
  sizeNavs();
});

$(window).on('load resize', function() {
  sizeNavs();
});

$(window).load(function() {
  // set top nav
  var logoRowHeight = $('#logo-greet').css('height');
  $('.logo-row').css('height', logoRowHeight);
});

function sizeNavs() {
  // for tablet flipping
  window.addEventListener("orientationchange", function() {
    var marginLeft = $('#global-sidebar').css('width');
    var contentMarginLeft1 = parseInt($('#global-sidebar').css('width'));
    var contentMarginLeft2 = parseInt($('#variable-sidebar').css('width')) || 0;
    $('#variable-sidebar').css('margin-left', marginLeft);
    $('#content').css('margin-left', contentMarginLeft1 + contentMarginLeft2);
  }, false);

  // set variable sidebar nav left margin in proportion to global side nav
  var liWidth = $('#global-sidebar').css('width');
  $('#gear-nav').css('width', liWidth);

  var marginLeft = $('#global-sidebar').css('width');
  $('#variable-sidebar').css('margin-left', marginLeft);

  // set margin of content in proportion to both side navs
  var contentMarginLeft1 = parseInt($('#global-sidebar').css('width'));
  var contentMarginLeft2 = parseInt($('#variable-sidebar').css('width')) || 0;
  $('#content').css('margin-left', contentMarginLeft1+contentMarginLeft2);

  // add active class on click for sidebar styling
  $('#variable-sidebar ul li').click(function () {
    $('#variable-sidebar ul li').removeClass('active-side-nav');
    $(this).addClass('active-side-nav');
  });

  // set default active nav for api_docs under 'Services' (editable api_docs)
  // var firstDoc = $("#documentation-wrap div.endpoint-select:first-of-type").data('name');
  // var activeLink = $("a.category-name:contains(" + firstDoc + ")");
  $("a.category-name").first().parent().addClass('active-side-nav');

  var winHeight = $(window).height();
  var topNav    = $('#top-nav').height();
  $('#services-sidebar, #jump-nav').css('max-height', winHeight - topNav);
}
