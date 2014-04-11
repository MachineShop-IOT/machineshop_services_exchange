$(document).ready(function() {
  // Load paged widgets...

  // Device Last Reports
  // page_it('.device_instances_reports', "/widget/get_device_instances", 1, function(){
  //   load_row('.report', "/widget/get_device_instance_last_report?device_id=", 'data-device_id', '.device_instances_reports')
  // });

  bulk_page('.device_instances_reports', "/widget/get_device_instances", 1);

  // Device summary
  // page_it('.device_instances_count', "/widget/get_device_instances_summary", 1, function(){
  //   load_row('.report_count', "/widget/get_device_instance_report_count?device_id=", 'data-device_id', '.device_instances_count')
  // });
  bulk_page('.device_instances_count', "/widget/get_device_instances_summary", 1);

  // Users
  page_it('.user_management', "/widget/retrieve_users", 1, function(){
    load_row('.user_info', "/widget/retrieve_user_by_id?user_id=", 'data-user_id', '.user_management')
  });

  // Customers
  page_it('.customer_management', "/widget/retrieve_customers", 1, function(){
    load_row('.customer_info', "/widget/retrieve_customer_by_id?user_id=", 'data-customer_id', '.customer_management')
  });

  // Rules
  page_it('.rule_management', "/widget/retrieve_rules", 1, function(){
    load_row('.rule_info', "/widget/retrieve_rule_by_id?rule_id=", 'data-rule_id', '.rule_management')
    //$(this).children("tr").attr('data-remote', 'true');
  });

  // Custom API's
  page_it('.custom_api_management', "/widget/retrieve_custom_apis", 1, function(){
    load_row('.custom_api_info', "/widget/retrieve_custom_api_by_id?custom_api_id=", 'data-custom-api_id', '.custom_api_management')
  });

  $(function () {
    $("#report_detail").modal({show:false});
  });

  $(function () {
    $("#device_instance_detail").modal({show:false});
  });

  $('#user_search').submit(function() {
    page_it('.user_management', "/widget/retrieve_users?query=" + $('#user-search-box').val(), 1, function(){
      load_row('.user_info', "/widget/retrieve_user_by_id?query="+ $('#user-search-box').val() + "&user_id=", 'data-user_id', '.user_management')
    });
    return false;
  });

  $('#customer_search').submit(function() {
    page_it('.customer_management', "/widget/retrieve_customers?query=" + $('#customer-search-box').val(), 1, function(){
      load_row('.customer_info', "/widget/retrieve_user_by_id?query="+ $('#customer-search-box').val() + "&user_id=", 'data-user_id', '.customer_management')
    });
    return false;
  });

  localTime();
});

function localTime() {
  $('.local-time').each(function() {
    // localize servertime of the record and make it a Date Object
    var now = new Date();
    var utcOffset = now.getTimezoneOffset() * 1000 * 60;
    var serverTime = $(this).text();
    var newTimeObject = new Date(serverTime);
    var localizedTime = new Date(newTimeObject - utcOffset);

    //Get displayable data from the Date Object
    var year = localizedTime.getFullYear();
    var month = localizedTime.getMonth() + 1;
    var day = localizedTime.getDate();
    var hours = localizedTime.getHours();

    //Tweaks: 24hour clock to 12, add a leading 0 to minutes less than 10, etc.
    var ampm = hours >= 12 ? 'PM' : 'AM'
    hours = hours % 12;
    hours = hours ? hours : 12;
    var minutes = (localizedTime.getMinutes() < 10 ? '0' : '') + localizedTime.getMinutes();

    if ($(this).text() != "") {
      $(this).text(month + "/" + day + "/" + year + " " + hours + ":" + minutes + " " + ampm);
      $(this).removeClass('local-time');
    }
  });
}

function page_it(target_body_class, load_endpoint, page, row_function){
  if (load_endpoint.indexOf("?") !== -1){
    $(target_body_class + ' .paged_data').load(load_endpoint + '&page=' + page,  row_function);
  } else {
    $(target_body_class + ' .paged_data').load(load_endpoint + '?page=' + page,  row_function);
  }

  $(target_body_class + ' a.previous').unbind('click');
  $(target_body_class + ' a.next').unbind('click');
  $(target_body_class + ' a.previous').click(function(){
    var page = parseInt(find_pager(target_body_class).attr('data-page')) - 1;
    if (page > 0) {
      find_pager(target_body_class).attr('data-page', page);
      $(target_body_class + ' .current_page').text(page).promise().done(function(){
        page_it(target_body_class, load_endpoint, page, row_function);
      });
    }
  });
  $(target_body_class + ' a.next').click(function(){
    var page = parseInt(find_pager(target_body_class).attr('data-page')) + 1;
    find_pager(target_body_class).attr('data-page', page);
    $(target_body_class + ' .current_page').text(page).promise().done(function(){
      page_it(target_body_class, load_endpoint, page, row_function);
    });
  });
}

function bulk_page(target_body_class, load_endpoint, page){
  if (load_endpoint.indexOf("?") !== -1){
    $(target_body_class + ' .paged_data').load(load_endpoint + '&page=' + page, function(){
      localTime();
    });
  } else {
    $(target_body_class + ' .paged_data').load(load_endpoint + '?page=' + page, function(){
      localTime();
    });
  }


  $(target_body_class + ' a.previous').unbind('click');
  $(target_body_class + ' a.next').unbind('click');
  $(target_body_class + ' a.previous').click(function(){
    var page = parseInt(find_pager(target_body_class).attr('data-page')) - 1;
    if (page > 0) {
      find_pager(target_body_class).attr('data-page', page);
      $(target_body_class + ' .current_page').text(page).promise().done(function(){
        bulk_page(target_body_class, load_endpoint, page);
      });
    }
  });

  $(target_body_class + ' a.next').click(function(){
    var page = parseInt(find_pager(target_body_class).attr('data-page')) + 1;
    find_pager(target_body_class).attr('data-page', page);
    $(target_body_class + ' .current_page').text(page).promise().done(function(){
      bulk_page(target_body_class, load_endpoint, page);
    });
  });
}

function load_row(target_body_class, load_endpoint, data_attr, parent_class) {
  var page = parseInt(find_pager(parent_class).attr('data-page'));
  $(target_body_class).each(function( index ) {
    $(this).load(load_endpoint + $(this).attr(data_attr) + '&page=' + page, function(){
      localTime();
    });
  });
}

function find_pager(parent_class){
  var value = $(parent_class + ' > .pager')
  if(value.length == 0){
    value = $(parent_class + ' .pager')
  }
  return value;
}
