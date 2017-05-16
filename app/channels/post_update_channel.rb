class PostUpdateChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams

    if params[:post_id]
      post = Post.find(params[:post_id])
      stream_for post
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
