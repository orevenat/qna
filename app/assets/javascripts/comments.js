$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('CommentsChannel', {
    connected() {
      if(!gon.question_id) {
        return;
      }
      return this.perform('follow', {
        question_id: gon.question_id
      });
    },
    received(data) {
      if (data.comment.user_id != gon.user_id) {
        resourceType = data.comment.commentable_type
        $('.' + resourceType.toLowerCase() + '_comments_' + data.comment.commentable_id).append(JST["templates/comment"](data))
      }
    }
  });
});
