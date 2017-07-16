module BootstrapHelper
  def link_to_active(name, options, html_options = {})
    if current_page?(options)
      html_options[:class] = Array(html_options[:class])
      html_options[:class] << 'active'
    end

    link_to name, options, html_options
  end
end
