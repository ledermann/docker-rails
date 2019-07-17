document.addEventListener('turbolinks:load', () => {
  const article = document.querySelector('article')
  if (!article) return

  const postId = article.dataset.cablePostId
  if (!postId) return

  App.updates = App.cable.subscriptions.create({ channel: 'PostUpdateChannel', post_id: postId }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log(`Connected to ${App.updates.identifier}`)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log(`Disconnected from ${App.updates.identifier}`)
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(`Received data from ${App.updates.identifier}`)

      // Reload the page
      Turbolinks.visit(window.location)
    }
  })
})
