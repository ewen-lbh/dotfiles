
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
    font-size: 2.75rem !important;
    font-family: Manrope;
}
`

document.head.append(style)
