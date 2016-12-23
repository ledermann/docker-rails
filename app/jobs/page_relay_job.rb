class PageRelayJob < ApplicationJob
  queue_as :default

  def perform(page)
    UpdatesChannel.broadcast_to page, :html => PagesController.render(partial: 'show', locals: { page: page })
  end
end
