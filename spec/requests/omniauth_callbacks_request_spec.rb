require 'rails_helper'
require 'omniauth'
describe OmniauthCallbacksController, type: :controller do
  it 'should set user_id while login with fb' do
    expect do
      login_with(:facebook)
    end
      .to change { User.count }.by(1)
    expect(controller.current_user).to eq(User.last)
  end

  it 'should set user_id while login with google' do
    expect do
      login_with(:google_oauth2)
    end
      .to change { User.count }.by(1)
    expect(controller.current_user).to eq(User.last)
  end

  it 'should get same user_id while login with gg fb' do
    login_with(:google_oauth2)
    first_current_user = controller.current_user

    sign_out first_current_user
    expect(controller.current_user).to eq(nil)

    login_with(:google_oauth2)
    expect(controller.current_user).to eq(first_current_user)
  end

  it 'should not get user_id while login with invalid info(email invalid)' do
    request.env['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({  'provider' => 'google_oauth2',
                                                                          'uid' => '123451234512345',
                                                                          'info' => { 'email' => 'test.testmail.com',
                                                                                      'name' => 'test',
                                                                                      'image' => '' } })
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    get :google_oauth2

    expect(controller.current_user).to eq(nil)
  end
end

def login_with(temp)
  request.env['devise.mapping'] = Devise.mappings[:user]
  temp == :facebook ? 'facebook' : 'google_oauth2'
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({  'provider' => temp,
                                                                   'uid' => '123451234512345',
                                                                   'info' => { 'email' => 'testuser@testmail.com',
                                                                               'name' => 'test', 'image' => '' } })
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  get temp
end
