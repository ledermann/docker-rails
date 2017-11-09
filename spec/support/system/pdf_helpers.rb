module SystemTest
  module PdfHelpers
    # Test PDFs with Capybara
    # https://content.pivotal.io/blog/how-to-test-pdfs-with-capybara
    def convert_pdf_to_page
      temp_pdf = Tempfile.new('pdf')
      temp_pdf << page.source.force_encoding('UTF-8')
      reader = PDF::Reader.new(temp_pdf)
      pdf_text = reader.pages.map(&:text)
      page.driver.response.instance_variable_set('@body', pdf_text)
    end
  end
end

RSpec.configure do |config|
  config.include SystemTest::PdfHelpers, type: :system
end
