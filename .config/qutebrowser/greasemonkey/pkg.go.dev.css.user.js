
// ==UserScript==
// @name Custom CSS: pkg.go.dev
// @description Custom CSS for pkg.go.dev
// @include https://pkg.go.dev/*
// @license MIT
// @version 0.0.1
// ==/UserScript==
//

style = document.createElement('style')
style.innerText = `
h4[data-kind] {
    font-family: Cartograph CF;
    letter-spacing: -0.03em;
}

.UnitHeader-title h1 {
    font-size: 2.75rem;
    font-family: Manrope;
}

@media (prefers-color-scheme: dark) {

	:root {
	  --gray-10: #202224;
	  --gray-9: #3e4042;
	  --gray-8: #555759;
	  --gray-7: #6e7072;
	  --gray-6: #848688;
	  --gray-5: #aaacae;
	  --gray-4: #c6c8ca;
	  --gray-3: #dcdee0;
	  --gray-2: #f0f1f2;
	  --gray-1: #fafafa;
	  --turq-dark: #5dc9e2;
	  --turq-med: #00add8;
	  --turq-light: #007e9e;
	  --black: #000;
	  --green: #83af61;
	  --white: #000;
	}

	.Overview-readmeContent a {
	    color: #69a9f1;
	}

	.Overview-readmeContent pre {
	    background-color: var(--gray-9);
	}


	.Overview-readmeContent hr {
	    background-color: var(--gray-9);
	}

	.Overview-readmeContent blockquote {
	    color: var(--gray-5);
	    border-left-color: var(--gray-6);
	}

	.Overview-readmeContent blockquote > :first-child {
	    background-color: var(--gray-9);
	}

	body {
	    background: var(--gray-10);
	}

	.Banner {
	    background-color: #000;
	}

	.Site-footer {
	    color: white;
	}

	a.Footer-link {
	    color: var(--gray-2);
	}

	.Footer-listItem a:link,
	.Footer-listItem a:visited {
	    color: var(--gray-3);
	}

	.DocNavMobile {
	    background-color: var(--gray-10);
	    color: var(--gray-1);
	}

	.DocNavMobile-select {
	    background: var(--gray-10);
	    color: var(--gray-1);
	}

	dialog {
	    background: black;
	    color: white;
	}

	.UnitMeta img[alt=unchecked] {
	    filter: invert(0.70);
	}

	.UnitDirectories-toggleButton img {
	    filter: invert(1);
	}

	.UnitHeader-overflowImage {
	    z-index: 100;
	    pointer-events: none;
	    background: black;
	}

	.UnitHeader-overflowSelect {
	    background: var(--gray-10);
	    color: var(--gray-1);
	}
}
`

document.head.append(style)
