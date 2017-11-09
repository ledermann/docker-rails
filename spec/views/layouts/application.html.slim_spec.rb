require 'rails_helper'

describe 'layouts/application' do
  before :each do
    without_partial_double_verification do
      allow(view).to receive(:title).and_return('We have a title')
    end
    render
  end

  it "should render title tag" do
    expect(rendered).to have_title('We have a title :: DockerRails')
  end
end
