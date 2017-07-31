class WordGamesController < ApplicationController
  def games
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
    @time_start = Time.now
  end

  def score
    @grid = JSON.parse(params[:grid])
    @attempt = params[:attempt]
    @time_start = Time.parse(params[:time_start])
    @time_end = Time.now
    @time_taken = @time_end - @time_start
    @score = score_and_message(@attempt, @grid, @time_taken)
  end

  def included?(guess, grid)
  guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end
  def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
  end

end
