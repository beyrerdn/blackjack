class Player
  attr_accessor :name,
                :hand,
                :bust,
                :score

  def initialize(name, score = 0)
    @name = name
    @hand = []
    @bust = false
    @score = score
  end

  def show_hand
    puts "#{name}'s hand(#{self.hand_total}):"
    hand.each do |card|
      puts "\t\t#{card.card_name}\n"
    end
  end

  def hand_total
    hand.inject(0){|sum, card| sum + card.value}
  end

  def hand_count
    hand.length
  end

end

class Dealer < Player

  def show_hand
    puts "#{name}'s hand:"
    hand.each_with_index do |card, index|
      if (hand.length < 3) && (index == 0)
        puts "\t\t--HOLE-CARD--\n"
      else
        puts "\t\t#{card.card_name}\n"
      end
    end
  end

  def show_hand_for_turn #would like to reference super.show_hand
    puts "#{name}'s hand(#{self.hand_total}):"
    hand.each do |card|
      puts "\t\t#{card.card_name}\n"
    end
  end

end
