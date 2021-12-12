# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'json'
require './lib/models/game'
require './lib/models/player'

class LogParser
  COMMANDS = %w[InitGame ShutdownGame Kill ClientUserinfoChanged].freeze

  attr_accessor :games

  def initialize(log_file)
    @log = log_file
    @games = []
    @game_index = 0
    @report = {}

    validate_params
    create_functions
    read_file
    build_report

    puts @report.to_json
  end

  def build_report
    games.each do |game|
      kills = grouped_kills_by_player(game)
      deaths = grouped_deaths(game)

      @report["game-#{game.index}"] = {
        "total_kills": game.total_kills,
        "players": game.players.map { |_k, v| v.name },
        "kills": kills, "kills_by_means": deaths
      }
    end
  end

  private

  def validate_params
    raise('ERROR: Argument file log not exists. Example: ruby log_parser.rb ./log/game.log') unless @log.present?
  end

  def grouped_kills_by_player(game)
    kills = {}
    game.players.each do |_k, v|
      kills[v.name.to_s] = v.kills
    end

    kills
  end

  def grouped_deaths(game)
    deaths = {}
    game.deaths.each do |k, v|
      deaths[(Game::MEANS_DEATH[k.to_i]).to_s] = v
    end

    deaths
  end

  def read_file
    File.foreach(@log) do |line|
      init_game?(line)
      client_userinfo_changed?(line)
      kill?(line)
      shutdown_game?(line)
    end
  end

  def create_functions
    COMMANDS.each do |method|
      self.class.define_method "#{method.underscore}?" do |line|
        send(method.underscore, line) if line.include?(method)
      end
    end
  end

  def init_game(_line)
    @game = Game.new(@game_index)
    @game_index += 1
  end

  def client_userinfo_changed(line)
    @game.add_player(Player.new.build(line))
  end

  def kill(line)
    info = line.scan(/Kill:.(.*?):/).flatten.first.split(' ')

    @game.kill_player(info[0], info[1], info[2])
  end

  def shutdown_game(_line)
    @games << @game
  end
end

LogParser.new(ARGV[0])
