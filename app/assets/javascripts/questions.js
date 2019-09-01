$(document).on('turbolinks:load', function(){
  var questionList = $(".questions-list")
  $('#question-area').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    var link = $(this)
    link.hide();
    $('form#question-form').removeClass('hidden');
  });

  App.cable.subscriptions.create('QuestionsChannel', {
    connected() {
      return this.perform('follow');
    },
    received(data) {
      return questionList.append(data);
    }
  });
});
