require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = (0..10).map { ('A'..'Z').to_a[rand(26)] }
  end

  # def duration
  #   session[:start_time] = Time.now
  #   end_time = Time.now
  #   @duration = end_time - session
  #   return @duration
  # end

  def score #duration)
    @letters = params[:grid].upcase.chars
    @word = params[:word]
    # # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    answer = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    output = JSON.parse(answer)
    word_array = @word.upcase.chars

    if output["found"] == true && word_checker(word_array, @letters)
      @message = "Well done!"
      # { score: word.length - ((end_time - session) / 10), time: end_time - session, message: "well done" }
    elsif word_checker(word_array, @letters) == false
      @message = "Word does not in the grid"
      # { score: 0, time: 0, message: "not in the grid" }
    else
      @message = "It's not an English word"
      # { score: 0, time: end_time - session, message: "not an english word" }
    end
  end


  def word_checker(word_array, letters)
    check = true
    word_array.each do |letter|
      check = false unless @letters.include? letter
      check = false unless word_array.count(letter) <= @letters.count(letter)
    end
    return check
  end
end
