
function scrollToBottom() {
    var element = document.querySelector("ul");
    element.scrollTop = element.scrollHeight;
}

function chatMsg(msg) {
    setTimeout(scrollToBottom, 100); // otherwise view gets updated after...
}

socrateaser.ports.chatMsg.subscribe(chatMsg);
