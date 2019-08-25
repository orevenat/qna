$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    $this = $(this);
    var response = e.detail[0];
    var rating = response['rating'];
    var user_voted = response['voted'];

    $this.find('.vote_rating span').html(rating);

    if (user_voted ) {
      $this.find('.vote_button').addClass('hidden');
      $this.find('.vote_cancel_button').removeClass('hidden');
    } else {
      $this.find('.vote_button').removeClass('hidden');
      $this.find('.vote_cancel_button').addClass('hidden');
    }
  });
});
