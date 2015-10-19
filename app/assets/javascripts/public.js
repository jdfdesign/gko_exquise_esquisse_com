//= require jquery_ujs
//= require jquery.placeholder
//= require jquery.easing
//= require jquery.mixitup
//= require jquery.imagesloaded
//= require jquery.touchSwipe

// make console.log safe to use
window.console || (console = {
  log: function() {}
});

window.THEME || (THEME = {
  filterState: "all",
  mode: "project"
});

jQuery(function($) {
  'use strict';

  /* ==================================================
  	Fix
  ================================================== */

  THEME.fix = function() {
    // fix for ie device_width bug 
    if (navigator.userAgent.match(/IEMobile\/10\.0/)) {
      var msViewportStyle = document.createElement("style");
      msViewportStyle.appendChild(document.createTextNode("@-ms-viewport{width:auto!important}"));
      document.getElementsByTagName("head")[0].appendChild(msViewportStyle);
    }
  };
  
  /* ==================================================
  	Placeholder
  ================================================== */

  THEME.placeholder = function() {
    // enable placeholder fix for old browsers
    $('input, textarea').placeholder();
  };
  
  /* ==================================================
  	Carousel
  ================================================== */

  THEME.carousel = function() {
    $('.carousel').each(function(index) {
      var that = $(this);

      // start the carousel if there is more than one image else hide controls
      if (that.find('.item').length > 1) {

      } else {
        that.find('.carousel-control').each(function(index) {
          $(this).css({ display: 'none' })
        })
        that.find('.carousel-indicators').each(function(index) {
          $(this).css({ display: 'none' })
        })
      }

      that.on("slide.bs.carousel", function(event) {
        // Bootstrap carousel marks the current slide (the one we're exiting) with an 'active' class
        var $currentSlide = $(this).find(".active iframe");
        //alert($currentSlide.html())
        // exit if there's no iframe, i.e. if this is just an image and not a video player
        if (!$currentSlide.length) {
          return;
        }

        // pass that iframe into Froogaloop, and call api("pause") on it.
        var player = Froogaloop($currentSlide[0]);
        player.api("pause");

      });
    });

    //Enable swiping...
		$(".carousel-inner").swipe( {
			//Generic swipe handler for all directions
			swipeLeft:function(event, direction, distance, duration, fingerCount) {
				$(this).parent().carousel('prev'); 
			},
			swipeRight: function() {
				$(this).parent().carousel('next'); 
			},
			//Default is 75px, set to 0 for demo so any distance triggers swipe
			threshold:0
		});
    
  };

  // ON RESIZE
  // ==================================================

  THEME.getScreenHeight = function() {
    var navbarHeight = $(".navbar").height();
    var winHeight = $(window).outerHeight();
    return Math.round(winHeight - navbarHeight);
  }
  
  // ON RESIZE
  // ==================================================

  THEME.resizing = function() {
    var navbarHeight = $(".navbar").height(),
        winHeight = $(window).outerHeight(),
        $carousel = $("#project-carousel"),
        $project = $('#project-wrapper'),
        $projects = $('#projects-wrapper'),
        projectsTop = 0;
    
    $project.css({ 'top': navbarHeight });
    
    if( $(window).outerWidth() > 768 ) {
      $carousel.css("max-height", Math.round(THEME.getScreenHeight() * 0.8) );
    }
    
    if(THEME.mode == "video") {
      projectsTop = Math.round( $("#player").height() + navbarHeight );
    }
    else {
      projectsTop = Math.round( $project.outerHeight(true) + navbarHeight );
    }
    
    $projects.css({ 'margin-top': projectsTop, "min-height": THEME.getScreenHeight() });
  };
  
  /*==================================================
  	Init
  ==================================================*/

  $(document).ready(function() {

    var $projects = $(".projects");

    $('a[data-filter]').on("click", function(e){
      if($("body").hasClass('off-canvas-open')) {
        $("body").removeClass('off-canvas-open');
      }
    })
    
    $("#btn-categories").on("click", function(e) {
      $("body").toggleClass('off-canvas-open');
    })

    $("a[data-remote]").on("ajax:beforeSend", function(evt, xhr, settings) {
      if ($(this).hasClass("active")) {
        return;
      };

      
      $('.thumbnail').removeClass("active");
      $(this).addClass("active");
      $("#project-container").hide();
      $(".throbber_page").show();
      $('body, html').stop().animate( { scrollTop: 0 }, 1500, 'easeOutExpo' );
    })
      .on("ajax:success", function(evt, xhr, settings) {
        var that = $(this),
          url = that.attr('href'),
          $container = $("#project-container");

        history.pushState(null, null, url);

        if (typeof(_gaq) != "undefined") {
          _gaq.push(['_trackPageview', url]);
        } else {
          console.log("_gaq disabled for _trackPageview" + url)
        }
        
        $container.html(eval(xhr));
        THEME.mode = "project";
        THEME.placeholder();
        THEME.carousel();
        
        // Check image loaded to adjust thmbnails height
        $('#project-carousel').imagesLoaded()
          .always(function(instance) {
            THEME.resizing();
            $(".throbber_page").hide();
          });

        $container.show();

        try {
          FB.XFBML.parse();
        } catch (e) {
          console.log("FB error");
        }
      })
      .on("ajax:error", function(evt, xhr, status, error) {
        var flash = $.parseJSON(xhr.getResponseHeader('X-Flash-Messages'));
        console.log("Site.error " + flash.error);
      });

    // Apply fix
    THEME.fix();
    THEME.placeholder();
    THEME.carousel();

    ///////////////////////////////////////////////////////
    // Handle Window Resizing
    
    $(window).resize(function() {
      THEME.resizing();
    })
    
    $('#projects-wrapper').imagesLoaded()
      .always(function(instance) {
        console.log("ok")
        THEME.resizing();
    });

    THEME.resizing();

  });
});