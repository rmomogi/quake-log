# frozen_string_literal: true

require './lib/models/player'

RSpec.describe Player do
  let(:line) do
    '0:34 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\xian/default\hmodel\xian/default\g_redteam'
  end
  let(:subject) { described_class.new }

  describe 'initialize' do
    it { expect(subject.kills).to be_zero }
  end

  describe '#build' do
    before { subject.build(line) }

    it { expect(subject.code).to eq '2' }
    it { expect(subject.name).to eq 'Isgalamido' }
  end

  describe '#kill!' do
    it 'increment killed players' do
      expect(subject.kill!).to eq 1
    end
  end

  describe '#lose_kill!' do
    it 'increment kill from player' do
      expect(subject.lose_kill!).to eq(-1)
    end
  end
end
