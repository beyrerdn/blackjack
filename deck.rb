require_relative 'card'

class Deck
  attr_accessor :cards

  #Create an Deck instance
  def initialize
    suits = ["Heart", "Diamond", "Spade", "Club"]
    values = [:Two, :Three, :Four, :Five, :Six, :Seven,
    :Eight, :Nine, :Ten, :Jack, :Queen, :King, :Ace]

    @cards = []
    suits.each do |suit|
      values.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    shuffle!
  end

  #Shuffle cards
  def shuffle!
    cards.shuffle! #needed to modify the deck
  end

  def card_count
    cards.length
  end

end

class Shoe < Deck

  attr_accessor :cards

  def initialize(num)
    suits = ["Heart", "Diamond", "Spade", "Club"]
    values = [:Two, :Three, :Four, :Five, :Six, :Seven,
    :Eight, :Nine, :Ten, :Jack, :Queen, :King, :Ace]

    @cards = []
    num.times do
      suits.each do |suit|
        values.each do |value|
          @cards << Card.new(suit, value)
        end
      end
      shuffle!
    end
  end
end
