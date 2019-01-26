class PostUpdateChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams

    return unless params[:post_id]

    post = Post.friendly.find(params[:post_id])
    stream_for post
  end

  def unsubscribed
    stop_all_streams
  end
end
