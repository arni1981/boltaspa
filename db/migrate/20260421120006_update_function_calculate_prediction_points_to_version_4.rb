class UpdateFunctionCalculatePredictionPointsToVersion4 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 4, revert_to_version: 3
  end
end
