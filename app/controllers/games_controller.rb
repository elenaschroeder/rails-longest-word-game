require 'JSON'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10).map { ('A'..'Z').to_a.sample }
    @grid = @letters.join(' ')
  end

  def score
    @word = params[:words]
    @grid = params[:grid]
    @final = new_score(@word, @grid)
  end

  def new_score(new_word, grid)
    comp_response = {}
    url = "https://wagon-dictionary.herokuapp.com/#{new_word}"
    dictionary_read = open(url).read
    dictionary_parsed = JSON.parse(dictionary_read)
    if dictionary_parsed['found'] && included?(new_word.upcase, grid)
      comp_response[:message] = 'Well done'
        comp_response
    elsif dictionary_parsed['found'] && included?(new_word.upcase, grid) == false
      comp_response[:message] = 'Not in the grid'
        comp_response
    else
      comp_response[:message] = 'Not an english word'
        comp_response
    end
  end

  def included?(word, grid)
    a = word.chars
    a.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
