class Player
  MAX_HEALTH = 20
  ESCAPE_HEALTH = 10

  def initialize
    @direction = :backward
    @health = MAX_HEALTH
  end

  def play_turn(warrior)
    space = warrior.feel @direction
    if space.wall?
      change_direction!
      warrior.walk! @direction
    elsif space.captive?
      warrior.rescue! @direction
    elsif space.enemy?
      warrior.attack!
    elsif taking_damage?(warrior) && critical_health?(warrior)
      @direction = :backward
      warrior.walk! @direction
    elsif !full_health?(warrior) && @direction == :backward
      warrior.rest!
      change_direction! if full_health?(warrior)
    else
      warrior.walk! @direction
    end

    @health = warrior.health
  end

  private

  def change_direction!
    @direction = @direction == :backward ? :forward : :backward
  end

  def critical_health?(warrior)
    warrior.health < ESCAPE_HEALTH
  end

  def full_health?(warrior)
    warrior.health == MAX_HEALTH
  end

  def taking_damage?(warrior)
    warrior.health < @health
  end
end
