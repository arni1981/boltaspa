class UpdateFunctionCalculatePredictionPointsToVersion9 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 9, revert_to_version: 8
  end
end
