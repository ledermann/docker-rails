import Turbolinks from 'turbolinks';
import consumer from './consumer';

document.addEventListener('turbolinks:load', () => {
  const article = document.querySelector('article');
  if (!article) return;

  const postId = article.dataset.cablePostId;
  if (!postId) return;

  consumer.subscriptions.create({
    channel: 'PostUpdateChannel', post_id: postId,
  }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected.');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('Disconnected.');
    },

    received() {
      // Called when there's incoming data on the websocket for this channel
      console.log('Received data.');

      // Reload the page
      Turbolinks.visit(window.location);
    },
  });
});
