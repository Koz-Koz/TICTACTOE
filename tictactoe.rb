require "rubygems"
require "pry"



#----------------------------------- BROADCASE ----------------------------------- 

class BoardCase

  attr_accessor :sign, :position
  # sign = (X, O, ou vide), position = son numéro de case

  def initialize position, sign = ''
    #TO DO doit régler sa valeur, ainsi que son numéro de case
    @sign = sign
    @position = position
  end

  def to_s
    #TO DO : doit renvoyer la valeur au format string
    puts "Vous avez entré #{sign} dans la position #{position.to_i+1}"
  end

end


#----------------------------------- BROAD ----------------------------------- 


class Board
  attr_accessor :boardcases
  #TO DO : la classe a 1 attr_accessor, une array qui contient les BoardCases


  def initialize
    #TO DO :
    #Quand la classe s'initialize, elle doit créer 9 instances BoardCases
    #Ces instances sont rangées dans une array qui est l'attr_accessor de la classe
    @boardcases = Array.new(9)
    @boardcases.each_with_index{ |_, i| @boardcases[i] = BoardCase.new(i, '') }         #_ est la cellule du tab. et le i = index

  end

  def to_s
    #TO DO : afficher le plateau
    boardcases.each_with_index do |b, i|
      print '[' + b.sign + ']'
      print "\n" if ((i+1) % 3 == 0)        
    end
  end


  def play position, sign
    #TO DO : une méthode qui change la BoardCase jouée en fonction de la valeur du joueur (X, ou O)
    boardcases[position.to_i].sign = sign
    boardcases[position.to_i].to_s                
  end

  def victory?
    #horizontals
    winning_positions = [] << [0, 1, 2] << [3, 4, 5] << [6, 7, 8]
    #verticals
    winning_positions << [0, 3, 6] << [1, 4, 7] << [2, 5, 8]
    #diagonals
    winning_positions << [0, 4, 8] << [2, 4, 6]

    winning_positions.each do |wp|
      # ['X', 'X', 'X']
      bc = [boardcases[wp[0]].sign, boardcases[wp[1]].sign, boardcases[wp[2]].sign]

      # Une ligne gagnante a obligatoirement 3 valeurs identiques
      # bc = ['X', 'X', '']
      # bc.reject(&:empty?)
      # ==> ['X', 'X']
      # bc.size
      # ==> 2
      # LIGNE NON GAGNANTE (doit être 3)
      # bc = ['X', 'X', 'O']
      # bc.uniq
      # ==> ['X', 'O']
      # bc.size
      # ==> 2
      # LIGNE NON GAGNANTE (doit être 1, valeur unique X ou O)
      return true if ((bc.reject(&:empty?).size == 3) && bc.uniq.size == 1)    
    end
    return false
  end
end


#----------------------------------- PLAYER ----------------------------------- 


class Player
  attr_accessor :sign, :first_name
  attr_writer :winner
  #TO DO : la classe a 2 attr_accessor, son nom, sa valeur (X ou O). Elle a un attr_writer : il a gagné ?

  def initialize(input = { winner: false })           
    #TO DO : doit régler son nom, sa valeur, son état de victoire
    @sign = input[:sign]
    @first_name = input[:first_name]
    @winner = input[:winner]
  end
end



#----------------------------------- GAME ----------------------------------- 


class Game
  attr_reader :player_1, :player_2, :board

  def initialize(required_input = {})                         
    # créér 2 joueurs, créé un board
    # les classes sont passées en paramètre pour réduire les dépendances de classe (dependency injection)
    # Les paramêtres sont nommés (hash avec clé) pour ne plus dépendre de l'ordonnancement (l'ordre)

    @player_1 = required_input[:player_1]         #clé player1
    @player_2 = required_input[:player_2]
    @board = required_input[:board]

    puts "Nom de l'utilisateur 1 :"
    first_name_1 = gets.chomp
    puts "Signe O ou X :"
    sign_1 = gets.chomp == 'X' ? 'X' : 'O'          
    puts "#{first_name_1} a le signe '#{sign_1}'"
    puts "Nom de l'utilisateur 2 :"
    first_name_2 = gets.chomp
    sign_2 = (sign_1 == 'O' ? 'X' : 'O')
    puts "#{first_name_2} a le signe '#{sign_2}'"

    @player_1.first_name, @player_1.sign = first_name_1, sign_1
    @player_2.first_name, @player_2.sign = first_name_2, sign_2
  end

  def go
    # TO DO : lance la partie
    puts "Que la partie commence !"
    turn
  end

  def turn
    # Afficher le plateau, demander au joueur il joue quoi, vérifier si un joueur a gagné, passe au joueur suivant si la partie n'est pas finie
    board.to_s
    @active_player = (@active_player == player_1 ? player_2 : player_1)
    puts "#{@active_player.first_name}, entrez un nombre entre 1 et 9"
    position = gets.chomp.to_i-1

    if !['X', 'O'].include?(board.boardcases[position.to_i].sign)
      board.play(position, @active_player.sign)
    else
      puts "Erreur cette position est déjà jouée"
      @active_player = (@active_player == player_1 ? player_2 : player_1)
      turn
    end

    if board.victory?
      @active_player.winner = true
      board.to_s
      puts "#{@active_player.first_name} a gagné !"
    else turn
    end
  end

end

Game.new({ player_1: Player.new, player_2: Player.new, board: Board.new }).go

# class User
#   attr_accessor :first_name

#   def initialize args
#     @first_name = args[:first_name]
#   end
# end

# @user = User.new
# @user = {first_name: 'Thomas'}
