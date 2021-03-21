require_relative '../lib/board'
require_relative '../lib/game'
require_relative '../lib/player'

describe Game do
  describe '#initialize' do
    it 'sends messages to Player and Board' do
      expect(Player).to receive(:new).twice
      expect(Board).to receive(:new).once
      described_class.new
    end
  end

  describe '#play' do
    context 'game ends in fourth round' do
      subject(:game) { Game.new }
      let(:player_one) { double('Player') }
      let(:player_two) { double('Player') }

      before do
        game.instance_variable_set(:@player_one, player_one)
        game.instance_variable_set(:@player_two, player_two)
        allow(player_one).to receive(:identify)
        allow(player_two).to receive(:identify)

        allow(game).to receive(:game_over?).and_return(false, false, false, false, true)
        allow(game).to receive(:play_turn)
        allow(game).to receive(:print_result)
      end

      it 'plays four turns' do
        expect(game).to receive(:play_turn).exactly(4).times
        game.play
      end
    end
  end

  describe '#game_over?' do
    subject(:game) { Game.new }
    let(:board) { double('Board') }

    before do
      game.instance_variable_set(:@board, board)
      allow(board).to receive(:game_over?)
    end

    it 'sends message to board' do
      expect(board).to receive(:game_over?).once
      game.game_over?
    end
  end

  describe '#play_turn' do
    subject(:game) { Game.new }
    let(:player_one) { double('Player') }
    let(:player_two) { double('Player') }

    before do
      game.instance_variable_set(:@player_one, player_one)
      game.instance_variable_set(:@player_two, player_two)
      allow(game).to receive(:play_single_turn)
    end

    context 'game ends after player one plays its turn and win' do
      it 'let play the turn just to player one' do
        allow(game).to receive(:game_over?).and_return(true)
        expect(game).to receive(:play_single_turn).with(player_one).once
        expect(game).not_to receive(:play_single_turn).with(player_two)
        game.play_turn
      end
    end

    context 'player one plays its turn and does not win' do
      it 'let both players to play their turns' do
        allow(game).to receive(:game_over?).and_return(false)
        expect(game).to receive(:play_single_turn).with(player_one).once
        expect(game).to receive(:play_single_turn).with(player_two).once
        game.play_turn
      end
    end
  end

  describe '#play_single_turn' do
    subject(:game) { Game.new }
    let(:player_one) { double('Player', name: 'Guillermo', number: 1) }
    let(:board) { double('Board') }

    before do
      game.instance_variable_set(:@player_one, player_one)
      game.instance_variable_set(:@board, board)
      allow(game).to receive(:puts)
      allow(game).to receive(:gets).and_return('')
      allow(board).to receive(:print_board)
      allow(board).to receive(:take_column)
    end

    context 'player puts a valid column' do
      before do
        allow(board).to receive(:valid_column?).and_return(true)
      end

      it 'sends message to board and player' do
        expect(board).to receive(:print_board).once
        expect(player_one).to receive(:name).once
        expect(board).to receive(:valid_column?).once
        expect(player_one).to receive(:number).once
        expect(board).to receive(:take_column).once
        game.play_single_turn(player_one)
      end
    end

    context 'player puts two invalid columns before a valid column' do
      before do
        allow(board).to receive(:valid_column?).and_return(false, false, true)
      end

      it 'asks player for column three times' do
        message = "\n#{player_one.name}, pick a column:"
        expect(game).to receive(:puts).with(message).exactly(3).times
        game.play_single_turn(player_one)
      end
    end
  end

  describe '#print_result' do
    subject(:game) { Game.new }
    let(:player_one) { double('Player', number: 1) }
    let(:player_two) { double('Player', number: 2) }
    let(:board) { double('Board') }

    before do
      game.instance_variable_set(:@board, board)
      allow(board).to receive(:print_board)
    end

    context 'whatever the result is' do
      before do
        winner_number = [player_one.number, player_two.number, false].sample
        allow(board).to receive(:winner).and_return(winner_number)
        allow(game).to receive(:print_winner)
        allow(game).to receive(:print_draw)
      end

      it 'sends message to board' do
        expect(board).to receive(:winner).once
        game.print_result
      end
    end

    context 'there is a winner' do
      before do
        allow(board).to receive(:winner).and_return(player_one.number)
        allow(game).to receive(:print_winner)
      end

      it 'prints winner' do
        expect(game).to receive(:print_winner).with(player_one.number).once
        game.print_result
      end
    end

    context 'it\'s a draw' do
      before do
        allow(board).to receive(:winner).and_return(false)
        allow(game).to receive(:print_draw)
      end

      it 'prints draw' do
        expect(game).to receive(:print_draw).once
        game.print_result
      end
    end
  end

  describe '#print_winner' do
    subject(:game) { Game.new }
    let(:player_one) { double('Player', name: 'Guillermo', number: 1) }
    let(:player_two) { double('Player', name: 'Martin', number: 2) }
    let(:board) { double('Board') }

    before do
      game.instance_variable_set(:@player_one, player_one)
      game.instance_variable_set(:@player_two, player_two)
      game.instance_variable_set(:@board, board)
      allow(game).to receive(:puts)
    end

    context 'whoever the winner is' do
      before do
        allow(game).to receive(:puts)
      end

      it 'sends message to player one to check if it is the winner' do
        winner_number = [player_one.number, player_two.number].sample
        expect(player_one).to receive(:number)
        game.print_winner(winner_number)
      end
    end

    context 'player one wins' do
      it 'prints winner' do
        message = "\n#{player_one.name} is the winner!"
        expect(game).to receive(:puts).with(message).once
        game.print_winner(player_one.number)
      end
    end

    context 'player two wins' do
      it 'prints winner' do
        message = "\n#{player_two.name} is the winner!"
        expect(game).to receive(:puts).with(message).once
        game.print_winner(player_two.number)
      end
    end
  end
end
