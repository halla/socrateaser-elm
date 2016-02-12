
function scrollToBottom() {
    var element = document.querySelector("ul");
    element.scrollTop = element.scrollHeight;
}

setInterval(scrollToBottom, 500);

//Main.ports.requestScrollBottom.subscribe(scrollToBottom);
