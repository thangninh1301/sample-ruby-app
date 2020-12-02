import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
    connected() {
        // Called when the subscription is ready for use on the server
        console.log('connected to action cable')
    },

    disconnected() {
        // Called when the subscription has been terminated by the server
    },

    received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log(data)
        $('#notifications-counter').html(data.counter)
        $('#notifications-list').prepend(data.notification)
    }
});
