import consumer from "./consumer"

consumer.subscriptions.create("ConversationsChannel", {
    connected() {
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        let selector = $("#list-massages-" + data.conversation_id)
        $.fn.not_exists = function () {
            return this.length == 0;
        }
        if (selector.not_exists()) {
            $("#chat-list").append(data.box_chat);
        } else {
            selector.append(data.messages)
        }
    }
});
