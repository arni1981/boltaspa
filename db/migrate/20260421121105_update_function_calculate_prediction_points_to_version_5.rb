class UpdateFunctionCalculatePredictionPointsToVersion5 < ActiveRecord::Migration[8.2]
  def change
    update_function :calculate_prediction_points, version: 5, revert_to_version: 4
  end
end
