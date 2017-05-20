module PiwikHelper
  def piwik_meta_tags
    if (piwik_host = ENV['PIWIK_HOST']) &&
       (piwik_id   = ENV['PIWIK_ID'])
      safe_join [
        tag(:meta, name: 'piwik-host', content: piwik_host),
        tag(:meta, name: 'piwik-id',   content: piwik_id)
      ], "\n"
    end
  end
end
