$(document).on 'turbolinks:load', ->
  page_id = $('.content').data('page-id')

  if page_id
    App.updates = App.cable.subscriptions.create { channel: "PageUpdateChannel", page_id: page_id },
      connected: ->
        # Called when the subscription is ready for use on the server
        console.log "Connected to " + App.updates.identifier

      disconnected: ->
        # Called when the subscription has been terminated by the server
        console.log "Disconnected from " + App.updates.identifier

      received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        console.log "Received data from " + App.updates.identifier
        $('.content').html(data.html)
        new Init()
