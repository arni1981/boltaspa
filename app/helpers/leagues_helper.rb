module LeaguesHelper
  def matchday_nav_link(direction, league_competition, current_round, compare_user)
    current_round = current_round.to_i

    target_round = direction == :prev ? current_round - 1 : current_round + 1
    is_disabled = if direction == :prev
                    current_round <= 1
                  else
                    current_round >= Match.where(competition: league_competition.competition).maximum(:matchday)
                  end

    path = league_competition_by_year_path(league_competition.league,
                                           league_competition.competition,
                                           league_competition.year,
                                           matchday: target_round,
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
end
