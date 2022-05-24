require 'open-uri'
require 'json'
require 'date'

class GamesController < ApplicationController
  def new
    gen_grid
  end

  def score
    query = params[:word]
    check_word(query)
  end

  private

  def gen_grid
    arr = ('A'..'Z').to_a
    @letters = []
    i = 0
    while i < 10
      @letters << arr.sample
      i += 1
    end
    @letters
  end

  def check_word(query)
    @data = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{query}").read)
    @message = "Congratz!"
    # @message = 'Your word is invalid, not from grid'
    if inside_grid && @data["found"]
      @message
    elsif @data["found"] && (inside_grid == false)
      @message = 'Your word is invalid, not from grid'
    else
      @message = 'It is not an english word'
    end
  end

  def inside_grid
    @data["word"].split("").each do |let|
      if params["letters"].split.include? let
        true
      else
        return false
      end
    end
  end
end
