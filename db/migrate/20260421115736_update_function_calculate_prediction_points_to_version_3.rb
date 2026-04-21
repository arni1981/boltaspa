class UpdateFunctionCalculatePredictionPointsToVersion3 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 3, revert_to_version: 2
  end
end
