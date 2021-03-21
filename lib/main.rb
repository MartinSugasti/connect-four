require_relative './game'

loop do
  Game.new.play

  puts "\nWould you like to play a new game? Type 'y' to start a new game!"
  break unless gets.chomp.downcase == 'y'
end

puts "\nHave a nice day!"
