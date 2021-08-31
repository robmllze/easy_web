// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// URL UTILS
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// Reference:
// - https://developer.mozilla.org/en-US/docs/Web/API/History/replaceState
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

//  <script src="url_utils.js"></script>

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

function urlReplaceState(data, title, url) {
    history.replaceState(data, title, [url]);
}

function urlPushState(data, title, url) {
    history.pushState(data, title, [url]);
}

// Removes the current page from the session history and navigates to the given URL.
function urlReplace(url) {
    window.location.replace(url);
}