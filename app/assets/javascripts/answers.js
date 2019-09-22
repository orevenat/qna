$(document).on('turbolinks:load', function(){
  var answersList = $(".answers")
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    var link = $(this)
    link.hide();
    var answerId = link.data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  App.cable.subscriptions.create('AnswersChannel', {
    connected() {
      if(!gon.question_id) {
        return;
      }
      return this.perform('follow', {
        question_id: gon.question_id
      });
    },
    received(data) {
      console.log(data);
      if (data.answer.user_id != gon.user_id) {
        answersList.append(JST["templates/answer"](data))
      }
    }
    // received(data) {
    //   // if data.answer.user_id != gon.user_id {
    //   //   $('.answers').append(JST["templates/answer"](data))
    //   // }
    // }
  });
});
