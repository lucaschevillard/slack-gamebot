require 'spec_helper'

describe SlackGamebot::Commands::Register, vcr: { cassette_name: 'user_info' } do
  let(:team) { Team.first || Fabricate(:team) }
  let(:app) { SlackGamebot::Server.new(team: team) }
  it 'registers a new user and promotes them to admin' do
    Fabricate(:user, team: Fabricate(:team)) # another user in another team
    expect do
      expect(message: "#{SlackRubyBot.config.user} register", user: 'user').to respond_with_slack_message("Welcome <@user>! You're ready to play. You're also a team admin.")
    end.to change(User, :count).by(1)
  end
  it 'registers a new user' do
    Fabricate(:user, team: team, is_admin: true)
    expect do
      expect(message: "#{SlackRubyBot.config.user} register", user: 'user').to respond_with_slack_message("Welcome <@user>! You're ready to play.")
    end.to change(User, :count).by(1)
  end
  it 'renames an existing user' do
    Fabricate(:user, user_id: 'user')
    expect do
      expect(message: "#{SlackRubyBot.config.user} register", user: 'user').to respond_with_slack_message("Welcome back <@user>, I've updated your registration. You're also a team admin.")
    end.to_not change(User, :count)
  end
  it 'already registered' do
    Fabricate(:user, user_id: 'user', user_name: 'username', is_admin: true)
    expect do
      expect(message: "#{SlackRubyBot.config.user} register", user: 'user').to respond_with_slack_message("Welcome back <@user>, you're already registered. You're also a team admin.")
    end.to_not change(User, :count)
  end
end
