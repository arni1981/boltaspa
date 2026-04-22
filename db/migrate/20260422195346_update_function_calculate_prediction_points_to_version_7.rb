class UpdateFunctionCalculatePredictionPointsToVersion7 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 7, revert_to_version: 6
  end
end
