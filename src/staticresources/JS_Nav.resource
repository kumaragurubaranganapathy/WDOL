$(document).ready(function(){

  //mobile hamburger

  $('#hamburger-menu').on( 'click', function(e){
      $('.mobile-nav').toggleClass('open');
  });

  // toggle user info for mobile
  $('#mobile-username-dropdown').on( 'click', function(e){
      $('#mobile-username-dropdown-content').slideToggle();
      $('#mobile-down-icon').toggleClass('glyphicon-menu-up')
      
  });

  // #username-dropdown-content
  $( '#username-dropdown' ).hover(
    function(){
      $('#username-dropdown-content').addClass('show');
    }, function(){
      $('#username-dropdown-content').removeClass('show');
    }
  );
});
