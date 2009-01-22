function IncludeJS(files) {
	if (files.length == 0) {
		return;
	}

	if (!document.createElement) {
		return;
	}

	for (index in files) {
		if ('/' + files[index][0] == document.location.pathname
				|| files[index][0] == '') {

			var script = document.createElement('script');

			if (script) {
				script.setAttribute('type', 'text/javascript');
				script.setAttribute('src', files[index][1]);
				var head = document.getElementsByTagName('head')[0];
				if (head) {
					head.appendChild(script);
				}
			}
		}
	}
}

function IncludeCSS(files) {
	if (files.length == 0) {
		return;
	}

	if (!document.createElement) {
		return;
	}

	for (index in files) {
		if ('/' + files[index][0] == document.location.pathname
				|| files[index][0] == '') {

			var csselem = document.createElement('link');

			if (csselem) {
				csselem.setAttribute('type', 'text/css');
				csselem.setAttribute('rel', 'stylesheet');
				csselem.setAttribute('href', files[index][1]);
				var head = document.getElementsByTagName('head')[0];
				if (head) {
					head.appendChild(csselem);
				}
			}
		}
	}
}