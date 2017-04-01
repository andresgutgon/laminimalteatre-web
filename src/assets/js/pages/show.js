$(function() {
  var videoModal = document.getElementById('modalTeaserVideo');
  var playerModal = new Vimeo.Player(videoModal);
  var video = document.getElementById('teaser');
  var player = new Vimeo.Player(video);
  player.ready().then(function() {
    $(video).addClass('teaser__iframe--visible');
    player.setVolume(0);

    $('#modalTeaser').on('shown.bs.modal', function (e) {
      $('body').addClass('modal-open--fullscreen');
      playerModal.play();
    })
    $('#modalTeaser').on('hide.bs.modal', function (e) {
      $('body').removeClass('modal-open--fullscreen');
      playerModal.pause();
    })
  });

  // Gallery initialization
  blueimp.Gallery(
    document.getElementById('playGallery'),
    { stretchImages: true }
  );
});
