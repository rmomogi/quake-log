# frozen_string_literal: true

class Player
  attr_accessor :code, :name, :kills

  def initialize
    @kills = 0
  end

  def build(line)
    log_parser(line)
  end

  def kill!
    @kills += 1
  end

  def lose_kill!
    @kills -= 1
  end

  private

  def log_parser(line)
    info = line.split(' ')

    @code = info[2]
    @name = line[/n\\(.*?)\\t\\/, 1]
    self
  end
end
