module Admin
  class VisitsController < Admin::BaseController
    schema(:show) do
      required(:id).filled(:integer)
    end

    def show
      @visit = Ahoy::Visit.find(safe_params[:id])
    end
  end
end
