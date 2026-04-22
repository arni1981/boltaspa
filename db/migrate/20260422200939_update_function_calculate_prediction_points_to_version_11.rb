class UpdateFunctionCalculatePredictionPointsToVersion11 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 11, revert_to_version: 10
  end
end
