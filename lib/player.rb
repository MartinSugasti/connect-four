class Player
  attr_reader :name, :number

  def initialize
    @name = nil
    @number = nil
  end

  def identify(number)
    @name = ask_name_to_user(number)
    @number = number
  end

  def ask_name_to_user(number)
    loop do
      puts "What's player #{number} name?"
      name = gets.chomp
      next unless name_is_valid?(name)

      return name
    end
  end

  def name_is_valid?(name)
    if name.strip.empty?
      puts 'Your name can\'t be empty.'
    else
      true
    end
  end
end
