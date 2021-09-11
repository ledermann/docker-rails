module PiwikHelper
  def piwik_meta_tags
    if (piwik_host = Rails.configuration.x.piwik_host) &&
       (piwik_id = Rails.configuration.x.piwik_id)
      safe_join [
        tag.meta(name: 'piwik-host', content: piwik_host),
        tag.meta(name: 'piwik-id',   content: piwik_id)
      ], "\n"
    end
  end
end
