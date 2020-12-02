import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        // Called when there's incoming data on the websocket for this channel
        let element_counter=$('#notifications-counter')
        let val= parseInt(element_counter.html())
        element_counter.html(++val)
        element_counter.css("visibility","visible")
        $('#notifications-list').prepend(data.notification)
    }
});
