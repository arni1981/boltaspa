module LeaguesHelper
  def matchday_nav_link(direction, league, competition, current_round, compare_user)
    target_round = direction == :prev ? current_round - 1 : current_round + 1
    is_disabled = direction == :prev ? current_round <= 1 : current_round >= 38

    path = league_competition_by_year_path(
      league_id: league.slug,
      competition_code: competition.code,
      matchday: target_round,
      year: 2025,
      compare_user_id: compare_user&.id
    )

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
