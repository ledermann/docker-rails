class PageRelayJob < ApplicationJob
  queue_as :default

  def perform(page)
    PageUpdateChannel.broadcast_to page, :html => PagesController.render(partial: 'show', locals: { page: page })
  end
end
