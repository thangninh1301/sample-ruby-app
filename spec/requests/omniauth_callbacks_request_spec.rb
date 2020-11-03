require 'rails_helper'
require 'omniauth'
describe OmniauthCallbacksController, type: :controller do
  it 'should set user_id while login with fb' do
    omit(:facebook)
    expect(session[:user_id]).to eq(User.last.id)
  end

  it 'should set user_id while login with google' do
    omit(:google_oauth2)
    expect(session[:user_id]).to eq(User.last.id)
  end

  it 'should not get user_id while login with invalid info(email invalid)' do
    request.env['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({  'provider' => 'google_oauth2',
                                                                          'uid' => '123451234512345',
                                                                          'info' => { 'email' => 'testuser.testmail.com', 'name' => 'test', 'image' => '' } })
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    get :google_oauth2

    expect(session[:user_id]).to eq(nil)
  end
end

def omit(temp)
  request.env['devise.mapping'] = Devise.mappings[:user]
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({  'provider' => temp == :facebook ? 'facebook' : 'google_oauth2',
                                                                   'uid' => '123451234512345',
                                                                   'info' => { 'email' => 'testuser@testmail.com', 'name' => 'test', 'image' => '' } })
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  get temp
end
