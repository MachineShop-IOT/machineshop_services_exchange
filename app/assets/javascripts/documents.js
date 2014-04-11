$(document).ready(function() {
  $('.endpoint-select').first().css('display', 'table-cell');
  $('.doc-info').first().show();

  $('li a.category-name').click(function() {
    var provider = $(this).attr('name');
    $.ajax({
      type: "GET",
      data: {"provider" : provider},
      url: '/documents/provider_docs',
      success: function(msg) {
        $('#documentation-wrap').html(msg);
        $('.endpoint-select').show();
        $('.doc-info').first().show();
        var winHeight = $(window).height();
        var topNav    = $('#top-nav').height();
        $('#services-sidebar').css('max-height', winHeight - topNav);
        $('.doc-info').css('padding-top', '0');
        $("[id*='category-description-edit-'], [id*='return_example_edit-'], [id*='example_code_edit-']").ckeditor();
        return false;
      },
      error: function(jqXHR, textStatus) {
        alert('something went wrong');
      }
    });
  });

  $(document).on('change', '.api-docs-select', function() {
    var option = $(this).children('option:selected');
    $('.doc-info, .edit-document').hide();
    $("#doc-info-" + ($(option).data('id'))).show();
  });

  $(document).on('click', '.edit-doc-link', function() {
    var id = $(this).data('id');
    $('.edit-document, .document').hide();
    $('#document-' + id).show();
  });

  $(document).on('click', '.save-doc-btn', function() {
    $('.edit-document > form').bind("ajax:success", function(evt, data, status, xhr) {
      var provider = $(this).data('service');
      var docId = $(this).data('form');
      $.ajax({
        type: "GET",
        data: {"provider" : provider},
        url: '/documents/provider_docs',
        success: function(msg) {
          $('#documentation-wrap').html(msg);
          $('.endpoint-select').show();
          var winHeight = $(window).height();
          var topNav    = $('#top-nav').height();
          $('#services-sidebar, #jump-nav').css('max-height', winHeight - topNav);
          $('option[data-id=' + docId + ']').prop('selected', true);
          $('#doc-info-' + docId).show();
          $("[id*='category-description-edit-'], [id*='return_example_edit-'], [id*='example_code_edit-']").ckeditor();
          return false;
        },
        error: function(jqXHR, textStatus) {
          alert('something went wrong');
        }
      });
    });
  });

  $('body').on('click', '.cancel-edit-doc', function() {
    $(".edit-document").hide();
    $(".document, .provider-desc").show();
  });

  // $(document).on('click', '.save-doc-btn', function() {
  //   $('.edit-document > form').bind("ajax:success", function(evt, data, status, xhr) {
  //     var id = $(this).data('form');
  //     $('.edit-document').hide();
  //     $('#doc-info-' + id).html(data);
  //     $('#document-' + id).show();
  //   });
  // });

  $(document).on('click', '.add-param', function() {
    $(this).parents('tr').after('<tr><td><input class="input-block-level" placeholder="No Parameters" name="parameters_keys[]" type="text"></input></td><td><input class="input-block-level" name="parameters_values[]" placeholder="No Parameters" type="text"></input></td><td><a class="remove-btn">Remove</a></td></tr>');
    // $('tbody.parameter-table > tr:last-child').hide();
  });

  $(document).on('click', 'a.remove-btn', function() {
    $(this).closest("tr").fadeOut(500);
  });

  $('#search_results').show();
  $('#search_results ul').css('margin-top', '2%');
  $('#search_results ul li a').css({'background': 'none', 'color': '#b3b3b3'});
});
