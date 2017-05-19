require 'rails_helper'

describe 'layouts/application' do
  before :each do
    without_partial_double_verification do
      allow(view).to receive(:body_js_class).and_return('ControllerAction')
      allow(view).to receive(:title).and_return('We have a title')
    end
    render
  end

  it "should render body tag with data attribute" do
    expect(rendered).to have_selector('body[data-js-class=ControllerAction]')
  end

  it "should render title tag" do
    expect(rendered).to have_title('We have a title :: DockerRails')
  end
end
