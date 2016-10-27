PDFKit.configure do |config|
  config.default_options = {
    page_size:       'A4',
    quiet:            true,
    print_media_type: true
  }
end
