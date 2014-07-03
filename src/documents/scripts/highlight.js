(function(window, $) {

	$(document).ready(highlightElement);
	$(window).hashchange(highlightElement);

	function highlightElement() {
		$(window.location.hash).effect('highlight', { color: '#fefc78' }, 1500);
	}
}(window, jQuery));