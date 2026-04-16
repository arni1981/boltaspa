module Admin
  class BaseController < ApplicationController
    before_action do
      redirect_to root_path unless Current.user&.admin?
    end
  end
end
