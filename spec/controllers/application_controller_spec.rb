require 'rails_helper'

describe ApplicationController do
  controller ApplicationController do
    def index
      head :ok
    end
  end

  describe '#title' do
    it 'returns nil per default' do
      expect(subject.title).to eq(nil)
    end

    it 'returns previously set string' do
      subject.title('foo')
      expect(subject.title).to eq('foo')
    end
  end
end
