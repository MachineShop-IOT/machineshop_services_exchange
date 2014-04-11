$(document).ready(function() {
  if($('#new-style-wrap').length > 0) {
    prePopulate();
  }

  $(document).on('click', '#restore-defaults > a', function() {
    prePopulate();
  });
});

function prePopulate() {
  $("option[value='Arial, Helvetica, sans-serif']").prop('selected', true);
  $('#style_background_color').css({'background-color':'rgb(255, 255, 255)', 'color':'rgb(0,0,0)'}).val('FFFFFF');
  $('#style_font_color').css({'background-color':'rgb(77,77,77)', 'color':'rgb(255,255,255)'}).val('4D4D4D');
  $('#style_link_color').css({'background-color':'rgb(47,58,63)', 'color':'rgb(255,255,255)'}).val('2F3A3F');
  $('#style_link_hover_color').css({'background-color':'rgb(0,85,128)', 'color':'rgb(255,255,255)'}).val('005580');
  $('#style_active_icon_color').css({'background-color':'rgb(211,164,74)', 'color':'rgb(255,255,255)'}).val('D3A44A');
  $('#style_backboards_color').css({'background-color':'rgb(211,164,74)', 'color':'rgb(255,255,255)'}).val('D3A44A');
}
