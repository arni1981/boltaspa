module TeamsHelper
  def localized_tla(team)
    I18n.t("team_names.#{team.tla.downcase}.tla")
  end

  def localized_short_name(team)
    I18n.t("team_names.#{team.tla.downcase}.name")
  end
end
