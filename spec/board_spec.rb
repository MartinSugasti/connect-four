require_relative '../lib/board'

describe Board do
  RED = "\u{1F534}"
  BLUE = "\u{1F535}"

  describe '#print_cell' do
    subject(:board) { described_class.new }

    before do
      sample_board = [
        [1, 2, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]
      ]
      board.instance_variable_set(:@board, sample_board)
    end

    it 'returns empty string' do
      expect(board.print_cell(0, 2)).to eq('  ')
    end

    it 'returns red chip' do
      expect(board.print_cell(0, 0)).to eq(RED)
    end

    it 'returns blue chip' do
      expect(board.print_cell(0, 1)).to eq(BLUE)
    end
  end

  describe '#valid_column?' do
    subject(:board) { described_class.new }

    before do
      board_with_full_column = [
        [1, nil, nil, nil, nil, nil, nil],
        [2, nil, nil, nil, nil, nil, nil],
        [1, nil, nil, nil, nil, nil, nil],
        [2, nil, nil, nil, nil, nil, nil],
        [1, nil, nil, nil, nil, nil, nil],
        [2, nil, nil, nil, nil, nil, nil]
      ]
      board.instance_variable_set(:@board, board_with_full_column)
      allow(board).to receive(:puts)
    end

    context 'selected column is invalid' do
      it 'returns false' do
        expect(board.valid_column?(10)).to be false
        expect(board.valid_column?(0)).to be false
        expect(board.valid_column?('0')).to be false
        expect(board.valid_column?('10')).to be false
      end

      it 'puts invalid column message' do
        message = 'Invalid column.'
        expect(board).to receive(:puts).with(message)
        board.valid_column?(10)
      end
    end

    context 'selected column is full' do
      it 'returns false' do
        expect(board.valid_column?(1)).to be false
      end

      it 'puts full column message' do
        message = 'That column is full.'
        expect(board).to receive(:puts).with(message)
        board.valid_column?(1)
      end
    end

    context 'selected column is valid and not full' do
      it 'returns true' do
        expect(board.valid_column?(2)).to be true
      end

      it 'does not put anything' do
        expect(board).not_to receive(:puts)
        board.valid_column?(2)
      end
    end
  end

  describe '#take_column' do
    subject(:board) { described_class.new }

    before do
      sample_board = [
        [1, 2, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]
      ]
      board.instance_variable_set(:@board, sample_board)
    end

    context 'player one choose empty column' do
      it 'changes first cell of column 3 to 1' do
        expect { board.take_column(3, 1) }
          .to change { board.instance_variable_get(:@board)[0][2] }.from(nil).to(1)
      end
    end

    context 'player two choose column with others chips' do
      it 'changes third cell of column 1 to 2' do
        expect { board.take_column(1, 2) }
          .to change { board.instance_variable_get(:@board)[1][0] }.from(nil).to(2)
      end
    end
  end

  describe '#draw?' do
    subject(:board) { described_class.new }

    context 'when there still are locations available' do
      before do
        complete_board = [
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, nil, 1, 2]
        ]
        board.instance_variable_set(:@board, complete_board)
      end

      it 'returns false' do
        expect(board.draw?).to be false
      end
    end

    context 'when there are not locations available' do
      before do
        incomplete_board = [
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, 2]
        ]
        board.instance_variable_set(:@board, incomplete_board)
      end

      it 'returns true' do
        expect(board.draw?).to be true
      end
    end
  end

  describe '#winner_by_row' do
    subject(:board) { described_class.new }

    context 'player 1 has four chips connected in a row' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 2, 2, 2],
          [1, 1, 1, 1, 2, 2, nil],
          [2, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 1' do
        expect(board.winner_by_row).to eq 1
      end
    end

    context 'player 2 has four chips connected in a row' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 2, 2, 2],
          [1, 1, 2, 2, 2, 2, 1],
          [nil, nil, 1, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 2' do
        expect(board.winner_by_row).to eq 2
      end
    end

    context 'there are not four chips connected in a row' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 1, 2, 1],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns false' do
        expect(board.winner_by_row).to eq false
      end
    end
  end

  describe '#winner_by_column' do
    subject(:board) { described_class.new }

    context 'player 1 has four chips connected in a column' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 2, 2, 2],
          [1, 1, 1, 2, 2, 2, nil],
          [1, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 1' do
        expect(board.winner_by_column).to eq 1
      end
    end

    context 'player 2 has four chips connected in a column' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 2, 2, 2],
          [1, 1, 2, 2, 2, 1, 1],
          [nil, nil, 2, nil, nil, nil, 1],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 2' do
        expect(board.winner_by_column).to eq 2
      end
    end

    context 'there are not four chips connected in a column' do
      before do
        sample_board = [
          [1, 1, 2, 1, 1, 2, 2],
          [1, 1, 2, 1, 1, 2, 1],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns false' do
        expect(board.winner_by_column).to eq false
      end
    end
  end

  describe '#winner_by_diagonal' do
    subject(:board) { described_class.new }

    context 'player 1 has four chips connected in a diagonal' do
      before do
        sample_board = [
          [1, 2, 1, 2, 1, 2, 1],
          [1, 2, 1, 2, 1, 2, 2],
          [1, 2, 1, 2, 1, 2, 1],
          [2, 1, 2, 1, 2, 1, nil],
          [2, 1, 2, 1, 1, 2, nil],
          [2, 1, 2, 1, 1, 2, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 1' do
        expect(board.winner_by_diagonal).to eq 1
      end
    end

    context 'player 2 has four chips connected in a diagonal' do
      before do
        sample_board = [
          [1, 2, 1, 1, 1, nil, nil],
          [1, 2, 2, 2, 1, nil, nil],
          [1, 2, 2, 2, 1, nil, nil],
          [nil, nil, nil, nil, 2, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns 2' do
        expect(board.winner_by_diagonal).to eq 2
      end
    end

    context 'there are not four chips connected in a diagonal' do
      before do
        sample_board = [
          [1, 1, 1, nil, 2, 2, 2],
          [1, 1, 1, nil, 2, 2, 2],
          [1, 1, 1, nil, 2, 2, 2],
          [2, 2, 2, nil, 1, 1, 1],
          [2, 2, 2, nil, 1, 1, 1],
          [2, 2, 2, nil, 1, 1, 1]
        ]
        board.instance_variable_set(:@board, sample_board)
      end

      it 'returns false' do
        expect(board.winner_by_diagonal).to eq false
      end
    end
  end
end
