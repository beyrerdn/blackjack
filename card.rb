class Card
  attr_accessor :suit,
                :value,
                :card_name,
                :face
  #Given a desired suit and value symbol, create a card
  def initialize(suit, value_hash_key)
    @suit = suit
    @value = {
                Two: "2",
                Three: "3",
                Four: "4",
                Five: "5",
                Six: "6",
                Seven: "7",
                Eight: "8",
                Nine: "9",
                Ten: "10",
                Jack: "10",
                Queen: "10",
                King: "10",
                Ace: "11"
                }
    @face = value_hash_key
    @value = @value[value_hash_key].to_i
    @card_name = "#{@face} of #{suit}s"
  end

  def == (card)
    self.value == card.value
  end

  def > (card)
    self.value > card.value
  end

  def < (card)
    self.value < card.value
  end

end
