// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// CHECK CONNECTION
//
// <#Author = Robert Mollentze>
// <#Date = 8/31/2021>
//
// References:
// - https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
// - https://developer.mozilla.org/en-US/docs/Web/API/NetworkInformation/type
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

// <script src="check_connection.js"></script>

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

function isOnline() {
    return navigator.onLine;
}

function connectionType() {
    const _connection = navigator.connection
        || navigator.mozConnection
        || navigator.webkitConnection;
    return _connection.type;
}

function isConnectedMobile() {
    const _res = connectionType();
    return _res != null ? (_res == "cellular") : null;
}

function isConnectedWifi() {
    const _res = connectionType();
    return _res != null ? (_res == "wifi") : null;
}