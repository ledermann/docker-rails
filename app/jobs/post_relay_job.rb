class PostRelayJob < ApplicationJob
  queue_as :default

  def perform(post)
    PostUpdateChannel.broadcast_to post, html: PostsController.render(action: 'show', layout: false, assigns: { post: post })
  end
end
