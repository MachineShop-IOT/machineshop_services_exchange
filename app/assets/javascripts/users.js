$(document).ready(function() {
  $(document).on('change', '#user_role', function() {
    if ($('#user_role option:selected').text() == 'Admin') {
      $('#put_user__id, #get_routes').prop('checked', true);
      $('#put_user__id, #get_routes').attr('checked', true);
      $('#put_user__id, #get_routes').attr('disabled', true);
      $('#put_user__id_hidden').attr('value', 'PUT/user/:id');
      $('#get_routes_hidden').attr('value', 'GET/routes');
    }
    else {
      $('#put_user__id_hidden, #get_routes_hidden').attr('value', '');
      $('#put_user__id, #get_routes').prop('checked', false);
      $('#put_user__id, #get_routes').attr('checked', false);
      $('#put_user__id, #get_routes').attr('disabled', false);
    }
  });
});

function toggleChecked(status) {
  $('.routes-by-resource').show();
  $('.show-hide-routes').text('-');
  $("#routes_container input[type=checkbox]").each( function() {
    $(this).prop("checked", status);
    if ($('#put_user__id, #get_routes').attr('disabled') == 'disabled') {
      $('#put_user__id, #get_routes').prop('checked', true);
    }
    if ($('#get_api_docs').attr('disabled') == 'disabled') {
      $('#get_api_docs').prop('checked', true);
    }
  });
};

function toggleRoutesCategory(elem) {
  var resource = $(elem).data('resource');
  var routes = $('.routes-by-resource[data-category=' + resource + ']');
  if ($(routes).css('display') == 'none') {
    $(routes).fadeIn();
    $(elem).text('-');
  }
  else {
    $(routes).fadeOut();
    $(elem).text('+');
  }
}

function showAllRoutes() {
  $('#expand-all').hide();
  $('.routes-by-resource, #collapse-all').show();
}

function hideAllRoutes() {
  $('#collapse-all, .routes-by-resource').hide();
  $('#expand-all').show();
}

function resetApiKey(elem) {
  var userId = $(elem).data('id');
  console.log(userId);
  $.ajax({
    type: "GET",
    data: {"id" : userId },
    url: '/users/new_api_key/' + userId,
    beforeSend: function() {
      $('#auth-token').text('Loading...').css('color', '#7cb3d8');
    },
    success: function(response) {
      if(response.api_key != null) {
        $('#auth-token').css('border-radius', '4px');
        $('#auth-token').text(response.api_key).effect("highlight", { color: '#ccffcc' }, 1500).css('color', '#999');
      }
      else {
        alert(response.error);
      }
    },
    error: function(jqXHR, textStatus) {
      alert(textStatus);
    }
  });
}
