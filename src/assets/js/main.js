var $hamburger = $('.js-header-mobile');
var $hamburgerIcon = $('.js-header-mobile .hamburger');
$hamburger.click(function () {
  $hamburgerIcon.toggleClass('hamburger--open');
  $('body').toggleClass('mobile-menu-open');
  $('.js-mobile-menu').toggleClass('animated bounceInUp');
});
