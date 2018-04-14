class PostRelayJob < ApplicationJob
  queue_as :default

  def perform(post)
    PostUpdateChannel.broadcast_to post, PostSerializer.new(post)
  end
end
