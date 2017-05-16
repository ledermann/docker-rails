require 'rails_helper'

describe PostRelayJob do
  it 'should broadcast' do
    post = create(:post)

    PostRelayJob.perform_now(post)

    # Currently, rspec-rails has no built-in support for testing ActionCable
    # https://github.com/rspec/rspec-rails/issues/1606
  end
end
