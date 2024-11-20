function scrollToLastMessage()
{
    if (document.getElementById('MessagesInChatdiv')) {
        var elem = document.getElementById('MessagesInChatdiv');
        elem.scrollTop = elem.scrollHeight;
        return true;
    }
    return false;
}