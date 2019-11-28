class PostRelayJob < ApplicationJob
  queue_as :default

  def perform(post)
    PostUpdateChannel.broadcast_to post, PostSerializer.new.serialize(post)
  end
end
