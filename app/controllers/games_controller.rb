require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # display a new random grid and a form
  def new
    @grid = generate_grid(10)
  end

  # The form will be submitted (with POST) to the score action.
  def score
    @word = params[:word]
    @grid = params[:grid]
    # raise
    @message = message_to_user(@word, @grid)
  end

  private

  def generate_grid(grid_size)
    grid_array = []
    grid_size.times do
      grid_array << ('A'..'Z').to_a.sample
    end
    grid_array
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    jsondata = JSON.parse(word_serialized)
    jsondata['found']
  end

  def valid_word_in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def message_to_user(word, grid)
    if !valid_word?(word)
      "Sorry but #{word.upcase} doest not seem to be a valid English word..."
    elsif !valid_word_in_grid?(word, grid)
      "Sorry but #{word} can't be build out of #{grid.split(',')}"
    end
  end
end
