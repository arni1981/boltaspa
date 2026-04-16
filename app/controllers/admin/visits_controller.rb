module Admin
  class VisitsController < Admin::BaseController
    def show
      @visit = Ahoy::Visit.find(safe_params[:id])
    end
  end
end
