
function scrollToBottom() {
    var element = document.querySelector("ul");
    element.scrollTop = element.scrollHeight;
}

function chatMsg(msg) {
    setTimeout(scrollToBottom, 100); // otherwise view gets updated after...
}

module.exports = { chatMsg: chatMsg };
