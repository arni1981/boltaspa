class UpdateFunctionCalculatePredictionPointsToVersion10 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 10, revert_to_version: 9
  end
end
