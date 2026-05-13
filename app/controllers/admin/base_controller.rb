# frozen_string_literal: true

module Admin
  # Base
  class BaseController < ApplicationController
    before_action :require_admin!
  end
end
