require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  include ActionCable::TestHelper
  # context 'when user is authenticated' do
  #   let(:user) { create(:user_mike) }
  #
  #   describe '#connect' do
  #     it 'accepts connection' do
  #       @request.session['user_id']=2
  #       expect { connect }.to_not raise_error
  #     end
  #   end
  # end

  context 'when user is not authenticated' do
    it 'should reject connection' do
      expect { connect '/cable' }.to have_rejected_connection
    end
  end
end
