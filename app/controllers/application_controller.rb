# frozen_string_literal: true

# fix rubocop
class ApplicationController < ActionController::Base
  include SessionsHelper
end
