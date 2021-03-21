class Board
  RED = "\u{1F534}"
  BLUE = "\u{1F535}"

  def initialize
    @board = Array.new(6) { Array.new(7) }
  end

  def game_over?
    winner || draw?
  end

  def print_board
    puts "\n  1    2    3    4    5    6    7   "
    puts '+----+----+----+----+----+----+----+'

    @board.each_with_index do |row, row_index|
      print_row(row, row_index)
    end
  end

  def print_row(row, row_index)
    row_to_string = '|'
    row.each_with_index do |_, column_index|
      row_to_string += " #{print_cell(5 - row_index, column_index)} |"
    end
    puts row_to_string
    puts '+----+----+----+----+----+----+----+'
  end

  def print_cell(row, column)
    case @board[row][column]
    when nil
      '  '
    when 1
      RED
    when 2
      BLUE
    end
  end

  def winner
    winner_by_row || winner_by_column || winner_by_diagonal
  end

  def draw?
    @board.each do |row|
      return false if row.any?(&:nil?)
    end

    true
  end

  def valid_column?(column)
    if (1..7).to_a.include?(column.to_i) && @board.last[column.to_i - 1].nil?
      true
    elsif (1..7).to_a.include?(column.to_i)
      puts 'That column is full.'
      false
    else
      puts 'Invalid column.'
      false
    end
  end

  def take_column(column, number)
    @board.each do |row|
      next unless row[column.to_i - 1].nil?

      row[column.to_i - 1] = number.to_i
      break
    end
  end

  def winner_by_row
    @board.each do |row|
      (0..3).to_a.each do |index|
        next if row[index].nil?
        if [row[index], row[index + 1], row[index + 2], row[index + 3]].uniq.length == 1
          return row[index]
        end
      end
    end

    false
  end

  def winner_by_column
    (0..6).each do |column_index|
      (0..2).to_a.each do |row_index|
        next if @board[row_index][column_index].nil?
        if [
          @board[row_index][column_index],
          @board[row_index + 1][column_index],
          @board[row_index + 2][column_index],
          @board[row_index + 3][column_index]
        ].uniq.length == 1
          return @board[row_index][column_index]
        end
      end
    end

    false
  end

  def winner_by_diagonal
    (0..5).to_a.each do |row_index|
      (0..6).to_a.each do |column_index|
        if (row_index + 3 <= 5) && (column_index + 3 <= 6) && @board[row_index][column_index]
          if [
            @board[row_index][column_index],
            @board[row_index + 1][column_index + 1],
            @board[row_index + 2][column_index + 2],
            @board[row_index + 3][column_index + 3]
          ].uniq.length == 1
            return @board[row_index][column_index]
          end
        end

        if (row_index - 3 >= 0) && (column_index - 3 <= 6) && @board[row_index][column_index]
          if [
            @board[row_index][column_index],
            @board[row_index - 1][column_index + 1],
            @board[row_index - 2][column_index + 2],
            @board[row_index - 3][column_index + 3]
          ].uniq.length == 1
            return @board[row_index][column_index]
          end
        end
      end
    end

    false
  end
end
