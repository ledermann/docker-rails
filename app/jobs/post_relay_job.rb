class PostRelayJob < ApplicationJob
  queue_as :default

  def perform(post)
    PostUpdateChannel.broadcast_to post,
                                   html: PostsController.render(partial: 'posts/show_article', locals: { post: post })
  end
end
