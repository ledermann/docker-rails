require 'rails_helper'

describe 'layouts/application' do
  before :each do
    without_partial_double_verification do
      allow(view).to receive(:body_js_class).and_return('ControllerAction')
    end
    render
  end

  it "should render body tag with data attribute" do
    expect(rendered).to have_selector('body[data-js-class=ControllerAction]')
  end
end
