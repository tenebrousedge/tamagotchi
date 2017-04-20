require "tama/version"

module Tama
  class Monster
    attr_reader :name
    attr_accessor :status

    def initialize(name, status, food_level, sleep_level)
      @name, @status, @food_level, @sleep_level = name, status, food_level, sleep_level
    end

    def method_missing(method, *args)
      if /^say/ =~ method
        # the $~ contains the last regex matched, so this line removes 'say' from the method name and then turns it into a string again (and returns that string)
        "#{method.to_s.sub($~.to_s, '')}!"
      elsif /^do/ =~ method
        increase_sleepiness
        increase_hunger
        "Your tamagotchi #{method.to_s.sub($~.to_s, '').downcase}s for a while."
      else
        increase_hunger
        increase_sleepiness
        "Your tamagotchi stares at you with a puzzled expression. Maybe try telling him to [say] or [do] Something"
      end
    end

    def dance
      increase_hunger
      "♪ ┏(°.°)┛ ┗(°.°)┓ ┗(°.°)┛ ┏(°.°)┓ ♪"
    end

    def feed
      @food_level += 3
      'Mmmm, tasty!'
    end

    def sleep
      @sleep_level = 0
      'Zzz' * 3
    end

    def increase_hunger
      @food_level -= 1
      if @food_level < 3
        "Careful, your pet is hungry"
      end
      if @food_level == 0
        @status = 'dead'
        freeze
      end
    end

    def increase_sleepiness
      @sleep_level += 1
      if @sleep_level >= 10
        @status = 'sleeping'
      end
    end
  end
  def self.new_tama(name)
    @tamas.merge!({name => Monster.new(name, 'awake', 10, 0)})
  end

  def self.get_tamas(name = nil)
    if name
      @tamas[name]
    else
      @tamas ||= {}
    end
  end

  def self.tama_action(method, tama)
    if tama.status == 'sleeping'
      "ssh, #{tama.name} is sleeping"
      tama.status = 'still sleeping'
    elsif tama.status == 'still sleeping'
      tama.status = 'waking up'
    elsif tama.status == 'waking up' || tama.status == 'awake'
      tama.send(method)
    elsif tama.status == 'dead'
      "Sorry, this tamagotchi died :("
    end
  end

end
