$(function() {
$(".screen_roll").css("opacity","0");


$(".screen_roll").hover(function () {

$(this).stop().animate({
opacity: 1
}, 400);
},

function () {

$(this).stop().animate({
opacity: 0
}, 400);
});
});

$(function() { 
	$('.screenshots a').lightBox();
});

$(document).ready(function() {
	$('.version,.twitter_btn,.facebook_btn,.rate1,.rate2,.rate3,.rate4').append('<span class="hover"></span>').each(function () {
  		var $span = $('> span.hover', this).css('opacity', 0);
  		$(this).hover(function () {
    		$span.stop().fadeTo(400, 1);
 		}, function () {
   	$span.stop().fadeTo(400, 0);
  		});
	});
});

$(document).ready(function() {
	$('#tweets').tweetable({username: 'cafetiereapp', time: true, limit: 2, replies: true, position: 'append'});
});

$(document).ready(function() {
	$('ul#quote_list').quote_rotator();
});
