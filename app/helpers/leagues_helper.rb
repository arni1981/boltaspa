module LeaguesHelper
  def matchday_nav_link(direction, league_competition, date, compare_user)
    target_date = if direction == :prev
                    league_competition.competition.prev_matchday(date)
                  else
                    league_competition.competition.next_matchday(date)
                  end

    is_disabled = if direction == :prev
                    league_competition.competition.prev_matchday(date).nil?
                  else
                    league_competition.competition.next_matchday(date).nil?
                  end

    path = league_competition_by_year_path(league_competition.league,
                                           league_competition.competition,
                                           league_competition.year,
                                           date: target_date,
                                           compare_user_id: compare_user&.id)

    link_to path,
            class: "p-1.5 hover:bg-white/10 rounded-lg text-white/40 transition-colors #{'opacity-20 pointer-events-none' if is_disabled}",
            data: { turbo_action: :advance } do
      tag.svg(class: 'w-4 h-4', fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24') do
        tag.path(
          stroke_linecap: 'round',
          stroke_linejoin: 'round',
          stroke_width: '3',
          d: direction == :prev ? 'M15 19l-7-7 7-7' : 'M9 5l7 7-7 7'
        )
      end
    end
  end

  def rank_display(membership)
    return '—' if membership.league.total_points.zero?

    "##{membership.rank}"
  end

  def member_count_display(league)
    t('.member_count', count: league.members_count)
  end
end
