class UpdateFunctionCalculatePredictionPointsToVersion6 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 6, revert_to_version: 5
  end
end
