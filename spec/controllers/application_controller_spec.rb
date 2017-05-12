require 'rails_helper'

describe ApplicationController do
  class DummiesController < ApplicationController; end

  controller DummiesController do
    def index
      head :ok
    end
  end

  describe 'body_js_class' do
    it "should named by controller_name and action_name" do
      get :index
      expect(controller.body_js_class).to eq('DummiesIndex')
    end
  end
end
