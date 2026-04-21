class UpdateFunctionCalculatePredictionPointsToVersion2 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 2, revert_to_version: 1
  end
end
