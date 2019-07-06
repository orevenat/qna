$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    var link = $(this)
    link.hide();
    var answerId = link.data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });
});
