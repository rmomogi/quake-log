# frozen_string_literal: true

class Game
  attr_reader :total_kills, :players, :deaths, :index

  WORLD = '1022'
  MEANS_DEATH = %w[
    MOD_UNKNOWN
    MOD_SHOTGUN
    MOD_GAUNTLET
    MOD_MACHINEGUN
    MOD_GRENADE
    MOD_GRENADE_SPLASH
    MOD_ROCKET
    MOD_ROCKET_SPLASH
    MOD_PLASMA
    MOD_PLASMA_SPLASH
    MOD_RAILGUN
    MOD_LIGHTNING
    MOD_BFG
    MOD_BFG_SPLASH
    MOD_WATER
    MOD_SLIME
    MOD_LAVA
    MOD_CRUSH
    MOD_TELEFRAG
    MOD_FALLING
    MOD_SUICIDE
    MOD_TARGET_LASER
    MOD_TRIGGER_HURT
    MOD_NAIL
    MOD_CHAINGUN
    MOD_PROXIMITY_MINE
    MOD_KAMIKAZE
    MOD_JUICED
    MOD_GRAPPLE
  ].freeze

  def initialize(index)
    @total_kills = 0
    @players = {}
    @deaths = {}
    @index = index
  end

  def add_player(player)
    @players[player.code] = player
  end

  def kill_player(player_code, killed_code, death_code)
    @total_kills += 1
    @deaths[death_code] = find_death(death_code) + 1

    world_kill?(player_code) ? find_player(killed_code).lose_kill! : find_player(player_code).kill!
  end

  private

  def world_kill?(player_code)
    player_code == WORLD
  end

  def find_player(code)
    @players[code]
  end

  def find_death(code)
    @deaths[code] || 0
  end
end
