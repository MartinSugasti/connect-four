require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @player_one = Player.new
    @player_two = Player.new
    @board = Board.new
  end

  def play
    @player_one.identify(1)
    @player_two.identify(2)

    play_turn until game_over?
    print_result
  end

  def game_over?
    @board.game_over?
  end

  def play_turn
    play_single_turn(@player_one)
    return if game_over?

    play_single_turn(@player_two)
  end

  def play_single_turn(player)
    loop do
      @board.print_board
      puts "\n#{player.name}, pick a column:"
      column = gets.chomp
      next unless @board.valid_column?(column)

      @board.take_column(column, player.number)
      break
    end
  end

  def print_result
    @board.print_board
    winner_number = @board.winner
    winner_number ? print_winner(winner_number) : print_draw
  end

  def print_winner(number)
    winner = number == @player_one.number ? @player_one : @player_two
    puts "\n#{winner.name} is the winner!"
  end

  def print_draw
    puts "\nIt's a draw!"
  end
end
