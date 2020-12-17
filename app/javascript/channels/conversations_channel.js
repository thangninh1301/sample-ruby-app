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
      $.ajax({
        type: "POST",
        data: {receiver_id: data.sender_id},
        url: "/conversations",
        dataType: "script"
      });
    } else {
      selector.append(data.messages)
    }
  }
});
