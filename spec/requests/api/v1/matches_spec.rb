require 'rails_helper'

describe API::V1::MatchesController, type: :request do
  let(:match) { create(:league_match) }

  describe 'GET #show' do
    let(:route) { '/api/v1/matches' }

    it 'succeeds for existing match' do
      get "#{route}/#{match.id}"

      json = JSON.parse(response.body)
      match_h = json['match']
      expect(match_h).to_not be_nil
      expect(match_h['forfeit_by']).to eq(match.forfeit_by)
      expect(match_h['status']).to eq(match.status)
      expect(match_h['league']['name']).to eq(match.league.name)
      expect(match_h['home_team']['name']).to eq(match.home_team.name)
      expect(match_h['away_team']['name']).to eq(match.away_team.name)

      teams = [match_h['home_team'], match_h['away_team']]
      teams.each do |team|
        expect(team['players']).to_not be_empty
      end

      expect(response).to be_success
    end

    it 'succeeds for non-existent match' do
      get "#{route}/-1"

      json = JSON.parse(response.body)
      expect(json['status']).to eq(404)
      expect(json['message']).to eq('Record not found')
      expect(response).to be_not_found
    end
  end
end
