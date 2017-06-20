class Player
  MAX_HEALTH = 20

  def initialize
    @health = MAX_HEALTH
  end

  def play_turn(warrior)
    if warrior.feel.enemy?
      warrior.attack!
    elsif taking_damage? warrior
      warrior.walk!
    elsif warrior.health < MAX_HEALTH
      warrior.rest!
    else
      warrior.walk!
    end

    @health = warrior.health
  end

  def taking_damage?(warrior)
    warrior.health < @health
  end
end
