# frozen_string_literal: true

class PlacesController < ApplicationController
  def states
    response = Services::Places.states
  end

  def cities
    response = Services::Places.cities(params['state_id'])
  end
end

#.map { |state| [state['nome'], state['id']] }.sort { |a, b| a <=> b }
