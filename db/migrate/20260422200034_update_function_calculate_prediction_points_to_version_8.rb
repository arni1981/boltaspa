class UpdateFunctionCalculatePredictionPointsToVersion8 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 8, revert_to_version: 7
  end
end
