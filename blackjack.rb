require_relative 'player'
require_relative 'deck'
require 'io/console'
#Allows user to play a game of blackjack.
#Game participants will be referred to as Dealer and Player 1
class Game
  attr_accessor :shoe,
                :player,
                :dealer

  def initialize
    @shoe = Shoe.new(7)
    puts "Welcome to the Blackjack table. What is your name? No capitalization needed, just type."
    name = get_player_name
    puts "Good luck #{name}."
    @player = Player.new(name)
    @dealer = Dealer.new("Dealer")
  end

  #Restarts the game based upon user input from 'again?'
  def reset
    @shoe = Shoe.new(7)
    player.hand.clear;
    player.bust = false
    dealer.hand.clear;
    dealer.bust = false
    play
  end

  #Starts gameplay
  def play
    2.times do
      self.hit(player)
    end
    2.times do
      self.hit(dealer)
    end
    check_for_blackjack
  end #End play

  #Receives input for the player's name using 'get_console_input'
  def get_player_name
    get_console_input.capitalize
  end

  #Get user input without displaying to command line
  def get_console_input
    STDIN.noecho(&:gets).chomp
  end

  #Get a single character from the user. Enter not needed
  def get_console_char
    STDIN.getch
  end

  #Early win conditions
  def check_for_blackjack
    if dealer.hand_total == 21
      puts "~~~Blackjack. Dealer wins!!!~~~" ; dealer.score += 1
      show_hands_final
      again?
    elsif player.hand_total == 21
      puts "~~~Blackjack. #{player.name} wins!~~~" ; player.score += 1
      show_hands_final
      again?
    else
      player_turns
    end
  end

  #Check for six cards, returns Boolean
  def six_cards?(player_check)
    if (player_check.hand.length == 6) && (player_check.hand_total < 21)
      return true
    else
      return false
    end
  end
  #Shows hands, hides Dealer's first card.
  def show_hands_initial
    player.show_hand
    dealer.show_hand
  end
  #Shows hands along with the Dealer's hidden card
  def show_hands_final
    player.show_hand
    dealer.show_hand_for_turn
  end

  #Deals cards and checks for Aces
  def hit(player_hit)
    card = shoe.cards.shift
    #Player's choice for each ace. Should allow player to reassign the Ace's
    ##value later (in bust cases). Idea: change code in hand_check
    if player_hit == player
      if (card.card_name.slice(0,3) == "Ace")
        response = ""
        puts "You drew an #{card.card_name}. Would you like it to equal 1 or 11? Please type '1' or '11' and press enter."
        response = gets.chomp
        if response == "1"
          card.value = 1
          player_hit.hand << card
        else response == "11"
          card.value = 11
          player_hit.hand << card
        end
      else
        player_hit.hand << card
      end
    #Dealer chooses based upon hand count
    elsif player_hit == dealer
      if card.card_name.slice(0,3) == "Ace"
        if (dealer.hand_total + 11) <= 21
          player_hit.hand << card
        elsif (dealer.hand_total + 11) > 21
          card.value = 1
          player_hit.hand << card
        end
      else
        player_hit.hand << card
      end
    end
  end #End hit

  #Player 1's choices for a single game
  def player_turns
    show_hands_initial
    response = ""
    until (response == "s") or (player.bust == true) or (player.hand_total == 21)
      puts "Would you like to hit or stay (h/s)"
      response = get_console_char
      if response == "h"
        self.hit(player)
        show_hands_initial
      elsif response == "s"
        puts "Good move!"
      else
        puts "You provided '#{response}'. Please provide 'h' or 's'."
        player_turns
      end
      hand_check(player)
    end
    dealer_turns
  end #End player_turn

  #Check for bust, 21, or six cards. Player 1 or Dealer
  def hand_check(player_check)
    if player_check.hand_total > 21
      player_check.bust = true
      puts "#{player_check.name} busted with #{player_check.hand_total}"
      winner
    elsif player_check.hand_total == 21
      winner
    elsif six_cards?(player_check) == true
      puts "~~~Six cards! #{player_check.name} wins!~~~" ; player_check.score += 1
      show_hands_final
      again?
    end 
  end

  #The dealer's choices for a single game
  def dealer_turns
    while (dealer.hand_total < 16)
      self.hit(dealer)
      hand_check(dealer)
    end
    winner
  end #End dealer_turn

  #Return Boolean for whether a player (Player 1 or Dealer) won the game
  def win?(player_check)
    other = ""
    player_check == player ? other = dealer : other = player
    if (player_check == player) && (player_check.hand_total == other.hand_total)
      return "Tie"
    elsif (player_check.bust == false) && (other.bust == false) && (player_check.hand_total > other.hand_total)
      return true
    elsif (player_check.hand_total == 21)
      return true
    elsif (player_check.bust == false) && (other.bust == false) && (player_check.hand_total < other.hand_total)
      return false
    elsif (player_check.bust == false) && (other.bust == true)
      return true
    elsif (player_check.bust == true) && (other.bust == false)
      return false
    # elsif (player_check.bust = true) && (other.bust == true)
    #   return "Bust"
    end
  end #End win?

  #Uses Boolean from win? to change score and display text to command line
  def winner
    if (win?(player) == true) && (win?(dealer) == false)
      show_hands_final
      puts "#{player.name} wins!!!\n" ;player.score += 1
    elsif (win?(dealer) == true) && (win?(player) == false)
      show_hands_final
      puts "#{dealer.name} wins!!!\n" ;dealer.score += 1
    # elsif (win?(player) == "Bust") || (win?(dealer) == "Bust")
    #   show_hands_final
    #   puts "#{player.name} and #{dealer.name} busted. It's a tie!\n"
    elsif win?(player) == "Tie"
      show_hands_final
      if player.hand_count > dealer.hand_count
        puts "\n#{player.name} and #{dealer.name} both show #{player.hand_total}.\n\n#{player.name} wins with #{player.hand.length} cards!!!"
        player.score += 1
      elsif dealer.hand_count > player.hand_count
        puts "\n#{player.name} and #{dealer.name} both show #{player.hand_total}.\n\nDealer wins with #{dealer.hand.length} cards!!!"
        dealer.score += 1
      else
        puts "\n#{player.name} and #{dealer.name} both show #{player.hand_total}.\n\n#{player.name} wins since both players have #{player.hand.length} cards!!!\n"
        player.score += 1
      end
    end
    again?
  end #End winner

  #Asks the user if he/she wants to play the game again
  def again?
    score
    puts "Would you like to play again? (y/n)"
    response = get_console_char
    if response == "y"
      reset
    elsif response == "n"
      puts "Thanks for playing. Have a nice day!"
      exit
    else
      puts "You said '#{response}'. Please clarify with 'y' or 'n'."
      again?
    end
  end #End again?

  #Displays running score to command line
  def score
    puts "---#{player.name.upcase}: #{player.score} -- #{dealer.name.upcase}: #{dealer.score}---"
  end

end #End Game class

Game.new.play
