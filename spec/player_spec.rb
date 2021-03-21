require_relative '../lib/player'

describe Player do
  describe '#identify' do
    subject(:player) { described_class.new }

    before do
      allow(player).to receive(:ask_name_to_user).and_return('Guillermo')
    end

    it 'sets Guillermo as the player name' do
      number = [1, 2].sample
      player.identify(number)
      expect(player.name).to eq('Guillermo')
    end

    context '1 is the identifier number' do
      it 'sets 1 as the player number' do
        player.identify(1)
        expect(player.number).to eq(1)
      end
    end

    context '1 is the identifier number' do
      it 'sets 1 as the player number' do
        player.identify(1)
        expect(player.number).to eq(1)
      end
    end
  end

  describe '#ask_name_to_user' do
    subject(:player) { described_class.new }

    before do
      allow(player).to receive(:gets).and_return('')
      allow(player).to receive(:puts)
    end

    context 'when user puts two invalid names and then a valid name' do
      before do
        allow(player).to receive(:name_is_valid?).and_return(false, false, true)
      end

      it 'ask for name three times' do
        player_number = 1
        message = "What's player #{player_number} name?"
        expect(player).to receive(:puts).with(message).exactly(3).times
        player.ask_name_to_user(player_number)
      end
    end
  end

  describe 'name_is_valid?' do
    subject(:player) { described_class.new }

    context 'name is valid' do
      let(:valid_name) { 'Guillermo' }

      it 'returns true' do
        expect(player.name_is_valid?(valid_name)).to be(true)
      end

      it 'does not puts any message' do
        expect(player).not_to receive(:puts)
        player.name_is_valid?(valid_name)
      end
    end

    context 'name is invalid' do
      let(:invalid_name) { ' ' }

      before do
        allow(player).to receive(:puts)
      end

      it 'returns falsy value' do
        expect(player.name_is_valid?(invalid_name)).to be_falsy
      end

      it 'puts wrong name message' do
        expect(player).to receive(:puts).with('Your name can\'t be empty.')
        player.name_is_valid?(invalid_name)
      end
    end
  end
end
