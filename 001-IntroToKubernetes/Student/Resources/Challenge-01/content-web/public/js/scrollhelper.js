var ScrollHelper = function()
{
	var exports = {};

	exports.scrollTo = function(hashOrId)
	{
		var hash = hashOrId.split('#').join(''),
            target = $('a[name='+hash+']');

        if (target.length === 0)
        {
        	target = $('#' + hash);
    	}

        var scroll_top = target.offset().top - 88;

        $('html, body').stop().animate(
	        {
	        	'scrollTop': scroll_top
			},
			700,
			'swing',
			function () {
	        }
        );

        ga('send', 'pageview', window.location.pathname + '-' + hash);
	};

	return exports;
}