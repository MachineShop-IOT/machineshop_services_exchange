$(document).ready(function() {
  var animated = false;
  var sender = null;
  $('.column').sortable({
    connectWith: '.column',
    handle: '.machineshop-header',
    placeholder: 'placeholder',
    forcePlaceholderSize: true,
    opacity: 0.4,
    start: function(event, ui) {
      //Firefox, Safari/Chrome fire click event after drag is complete, fix for that
    },
    stop: function(event, ui) {


      $('#' + sender.attr('id') + ' > .dragbox').animate({top: "+=30"}, 300, "easeOutBounce");
      if (ui.item.parent().attr('id') == sender.attr('id')){
        ui.item.animate({top: "-=30"}, 300, "easeOutElastic");
      } else {
        ui.item.animate({top: "-=30"}, 150, "easeInOutBack");
        ui.item.animate({top: "+=30"}, 300, "easeOutBounce");
      }
      animated = false;
      updateWidgetState();
    },
    change: function(event, ui) {
      if (ui.sender != null && !animated){
        $('#' + ui.sender.attr('id') + ' > .dragbox').animate({top: "-=30"}, 300, "easeInOutBack");
        sender = ui.sender;
        animated = true;
      }
    },
    revert: 300,
    scroll: true
  });

  $('.expand-widget').each(function() {
    var expand = $(this).parent();
    $(this).click(function(){
      $(expand).siblings('.machineshop-inner-container').attr('data-collapse','false');
      $(expand).siblings('.machineshop-inner-container').animate({height: "show"},
        { duration: 900,
          complete: updateWidgetState(),
          easing: "easeOutBounce"
        });//.show();
      $(this).prev('li.collapse-widget').css('display', 'inline-block');
      $(this).hide();
      //setTimeout(updateWidgetState(),1020);
    });
  });

  $('.collapse-widget').each(function() {
    var collapse = $(this).parent();
    $(this).click(function(){
      $(collapse).siblings('.machineshop-inner-container').attr('data-collapse','true');
      $(collapse).siblings('.machineshop-inner-container').animate({height: "hide"},
        { duration: 900,
          complete: updateWidgetState(),
          easing: "easeInOutBack"
        });      $(this).hide();
      $(this).siblings('.expand-widget').show();
      //setTimeout(updateWidgetState(),1020);
    });
  });

});

function widgetColumn(columnId){
  if (columnId.indexOf('left') !== -1){
    return 1
  } else {
    return 2
  }
}

function updateWidgetState() {
  var items = [];
  $('.column').each(function() {
    var columnId=$(this).attr('id');
    $('.dragbox', this).each(function(i) {
      var collapsed = false;
      if($(this).find('.machineshop-inner-container').attr('data-collapse')=="true")
        collapsed = true;
      //Create Item object for current panel
      var item = {
        widget_id: $(this).data('widget_id'),
        position: i,
        column: widgetColumn(columnId),
        collapsed: collapsed,
      };
      //Push item object into items array
      items.push(item);
    });
  });

  var sortorder = { items: items, user: $('#user_id').val() };
  //Pass sortorder variable to server using ajax to save state

  $.ajax({
    type: 'get',
    url: '/dashboard/save_widgets_state/',
    dataType: 'script',
    data: sortorder,
    cache: false
  });
}
