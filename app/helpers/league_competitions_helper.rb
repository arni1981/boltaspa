module LeagueCompetitionsHelper
  def performance_tier(pts)
    case pts
    when 0
      # INACTIVE: Ghost state
      ['bg-slate-50/50', 'text-slate-300', 'border-slate-100']
    when 25
      # BULLSEYE: Brand reward
      ['bg-[#2d5a43]', 'text-white', 'border-[#2d5a43] shadow-sm shadow-[#2d5a43]/20']
    when 12..24
      # SUCCESS: Midnight high-contrast
      ['bg-[#0a1d13]', 'text-white', 'border-[#0a1d13]']
    else
      # NOMINAL: Standard ledger entry
      ['bg-white', 'text-[#0a1d13]', 'border-slate-200']
    end
  end
end
