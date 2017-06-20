class Player
  def initialize
    @max_health = 20
    @health = @max_health
    @directions = [:left, :right, :forward, :backward]
  end

  def feel_surroundings(warrior)
    @surroundings = {}
    @directions.each {|d| @surroundings[d] = warrior.feel d}
  end

  def direction_of
    @surroundings.select {|k,v| yield(v) }.keys.first
  end

  def play_turn(warrior)
    feel_surroundings warrior
    captive_count = @surroundings.values.count {|s| s.captive?}
    enemy_count = @surroundings.values.count {|s| s.enemy?}

    if enemy_count > 1
      warrior.bind! direction_of {|s| s.enemy?}
    elsif enemy_count == 1
      warrior.attack! direction_of {|s| s.enemy?}
    elsif warrior.health < @max_health && warrior.health >= @health
      warrior.rest!
    elsif captive_count > 0
      warrior.rescue! direction_of {|s| s.captive?}
    else
      units = warrior.listen
      stairs_dir = warrior.direction_of_stairs
      direction = if units.empty?
        then stairs_dir
        else warrior.direction_of units.first
      end

      if ! units.empty? && direction == stairs_dir
        direction = direction_of {|s| s.empty? }
      end

      warrior.walk! direction
    end
    @health = warrior.health
  end
end
  
