$('a.js-scroll-header-item[href*="#"]:not([href="#"])').click(function() {
  var activeClass = 'header__nav__item--active';
  $('.header__nav__item').removeClass(activeClass);
  $(this).addClass(activeClass);
  if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
    var target = $(this.hash);
    var header = 80;
    target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
    if (target.length) {
      $('html, body').animate({
        scrollTop: target.offset().top - header
      }, 500);
      return false;
    }
  }
});
