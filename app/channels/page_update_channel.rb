class PageUpdateChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams

    if params[:page_id]
      page = Page.find(params[:page_id])
      stream_for page
    end
  end

  def unsubscribed
    stop_all_streams
  end
end
