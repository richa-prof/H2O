$(document).ready(function() {

  $('#carousel').flexslider({
    animation: "slide",
    controlNav: false,
    animationLoop: false,
    slideshow: false,
    itemWidth: 256,
    itemMargin: 10,
    asNavFor: '#slider'
  });

  $('#slider').flexslider({
    animation: "slide",
    controlNav: false,
    animationLoop: false,
    slideshow: false,
    sync: "#carousel",
    start: function(slider){
      $('body').removeClass('loading');
    }
  });

  $('.special-included-bg .owl-carousel').owlCarousel({
    navText: ['<i class="fa fa-angle-left" aria-hidden="true"></i>','<i class="fa fa-angle-right" aria-hidden="true"></i>'],
    margin: 30,
    nav: true,
    loop: false,
    items: 3,
    autoplay: true,
    autoplayTimeout: 2500,
    autoplayHoverPause: true
  });


  $('.whattake-box .owl-carousel').owlCarousel({
    margin: 10,
    nav: true,
    loop: false,
    items: 6
  });

  $('.banner-bg .owl-carousel').owlCarousel({
    navText: ['<i class="fa fa-angle-left" aria-hidden="true"></i>','<i class="fa fa-angle-right" aria-hidden="true"></i>'],
    margin: 0,
    nav: true,
    loop: true,
    items: 1,
    autoplay: true,
    autoplayTimeout: 2500,
    autoplayHoverPause: true
  });

  $('.specialdeals-bg .owl-carousel').owlCarousel({
    navText: ['<i class="fa fa-angle-left" aria-hidden="true"></i>','<i class="fa fa-angle-right" aria-hidden="true"></i>'],
    margin: 30,
    nav: true,
    loop: true,
    responsive: {
      0 : {
        items: 1
      },
      568 : {
        items: 2
      },
      1024 : {
        items: 3
      }
    }
  });

  $('.specialdeals-bg .owl-carousel-hotel').owlCarousel({
    margin: 30,
    nav: true,
    loop: true,
    responsive: {
      0 : {
        items: 1
      },
      568 : {
        items: 1
      },
      1024 : {
        items: 1
      }
    }
  });

  $('.testimonials-bg .owl-carousel').owlCarousel({
    navText: ['<i class="fa fa-angle-left" aria-hidden="true"></i>','<i class="fa fa-angle-right" aria-hidden="true"></i>'],
    margin: 25,
    nav: true,
    loop: true,
    items: 2,
    center: true,
    autoplay: true,
    autoplayTimeout:3000,
    autoplayHoverPause: true
  });

  // $('.grid').masonry();

  $("#price_range, #duration, #distance, #rooms").slider();

});
