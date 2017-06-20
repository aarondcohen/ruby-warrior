class Player
  def initialize
    @max_health = 20
    @too_far = 20
    @health = @max_health
    @direction = :backward
  end
  
  def change_direction!
    @direction = @direction == :backward ? :forward : :backward
  end
  
  def play_turn(warrior)
    feelings = warrior.feel @direction
    sights = warrior.look @direction
    captive_position = sights.index {|s| s.captive?} || @too_far
    enemy_position = sights.index {|s| s.enemy? } || @too_far

    if enemy_position < captive_position
      if feelings.enemy?
        warrior.attack! @direction
      else
        warrior.shoot! @direction
      end
    elsif warrior.health < @max_health && warrior.health >= @health
      change_direction! if warrior.health * 1.1 >= @max_health
      warrior.rest!
    elsif feelings.wall?
      warrior.pivot!
    elsif feelings.captive?
      warrior.rescue! @direction
      change_direction!
    else
      warrior.walk! @direction
    end
    @health = warrior.health
  end
end
  
