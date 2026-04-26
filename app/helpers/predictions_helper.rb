module PredictionsHelper
  def score_group_options(current_val)
    goals = (0..4).to_a
    all = goals.product(goals)

    groups = {
      t('predictions.match_row.groups.home_win') => all.select { |h, a| h > a }.sort_by { |h, a| [h + a, h] },
      t('predictions.match_row.groups.draw') => all.select { |h, a| h == a },
      t('predictions.match_row.groups.away_win') => all.select { |h, a| h < a }.sort_by { |h, a| [h + a, a] }
    }

    capture do
      groups.each do |label, scores|
        concat content_tag(:optgroup, label: label) {
          scores.each do |h, a|
            val = "#{h}-#{a}"
            concat content_tag(:option, "#{h} - #{a}", value: val, selected: (val == current_val))
          end
        }
      end
    end
  end
end
