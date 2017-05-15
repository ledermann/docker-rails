class PageRelayJob < ApplicationJob
  queue_as :default

  def perform(page)
    PageUpdateChannel.broadcast_to page, html: PagesController.render(action: 'show', layout: false, assigns: { page: page })
  end
end
