module MatchesHelper
  def format_goal_difference(difference)
    return '0' if difference.zero?

    difference.positive? ? "+#{difference}" : difference.to_s
  end
end
