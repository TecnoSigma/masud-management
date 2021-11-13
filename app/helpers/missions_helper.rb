# frozen_string_literal: true

module MissionsHelper
  def mission_fullnames_with_document(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.fullnames_with_document(mission.mission_history)
    else
      MissionsPresenter.fullnames_with_document(mission.team.agents)
    end
  end

  def mission_guns(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.guns(mission.mission_history)
    else
      MissionsPresenter.guns(mission.team.agents)
    end
  end

  def mission_munitions(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.munitions(mission.mission_history)
    else
      MissionsPresenter.munitions(mission.team.agents)
    end
  end

  def mission_waistcoats(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.waistcoats(mission.mission_history)
    else
      MissionsPresenter.waistcoats(mission.team.agents)
    end
  end

  def mission_radios(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.radios(mission.mission_history)
    else
      MissionsPresenter.radios(mission.team.agents)
    end
  end

  def mission_vehicles(mission)
    if mission.finished_at.present?
      MissionsHistoryPresenter.vehicles(mission.mission_history)
    else
      MissionsPresenter.vehicles(mission.team)
    end
  end
end
