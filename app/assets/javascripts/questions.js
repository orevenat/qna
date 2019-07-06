$(document).on('turbolinks:load', function(){
  $('#question-area').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    var link = $(this)
    link.hide();
    $('form#question-form').removeClass('hidden');
  });
});
