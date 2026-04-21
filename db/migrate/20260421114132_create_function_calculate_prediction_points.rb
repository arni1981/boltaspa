class CreateFunctionCalculatePredictionPoints < ActiveRecord::Migration[8.2]
  def change
    create_function :calculate_prediction_points
  end
end
