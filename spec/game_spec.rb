# frozen_string_literal: true

require './lib/models/game'
require './lib/models/player'

RSpec.describe Game do
  let(:player) { double(:Player, code: 99, name: 'Player', kills: 0) }
  let(:subject) { described_class.new(index) }
  let(:index) { 1 }

  describe 'initialize' do
    it { expect(subject.total_kills).to eq 0 }
    it { expect(subject.index).to eq 1 }
    it { expect(subject.players.length).to be_zero }
    it { expect(subject.deaths.length).to be_zero }
  end

  describe '#add_player' do
    it 'add player' do
      subject.add_player(player)

      expect(subject.players[player.code]).to eq player
    end
  end

  describe '#kill_player' do
    let(:kills_player2) { 10 }
    let(:player2) { build(:player, kills: kills_player2) }
    let(:player3) { build(:player, kills: 0) }
    let(:world) { Game::WORLD }

    before do
      subject.add_player(player2)
      subject.add_player(player3)
    end

    it 'player killed from world' do
      subject.kill_player(world, player2.code, 22)

      expect(player2.kills).to eq kills_player2 - 1
    end

    it 'player kill' do
      subject.kill_player(player3.code, player2.code, 1)

      expect(player3.kills).to eq 1
    end
  end
end
