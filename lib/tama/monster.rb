
module Tama
  class Monster
    attr_reader :name, :image
    attr_accessor :status, :strength

    def initialize(name, status = 'awake', food_level = 10, sleep_level = 10, strength = 1)
      @name = name
      @status = status
      @food_level = food_level
      @sleep_level = sleep_level
      @strength = strength
      @@alltamas ||= {}
      @@alltamas[name] = self
      @image = ['ヾ(=ﾟ･ﾟ=)ﾉ', '( ^..^)ﾉ', '=＾● ⋏ ●＾=', '(=｀ェ´=)', 'ᕦ〳 ⊙ ڡ ⊙ 〵ᕤ',\
        ' ԅ| . ͡° ڡ ͡° . |ᕤ', 'ฅ^•ﻌ•^ฅ', '(❍ᴥ❍ʋ)', 'ʕ•ᴥ•ʔ'].sample
    end

    def method_missing(method, *args, &block)
      if /^say/i =~ method
        # the $~ contains the last regex matched, so this line removes 'say' from the method name and then turns it into a string again (and returns that string)
        "#{method.to_s.sub($~.to_s, '')}!"
      elsif /^do/i =~ method
        increase_sleepiness
        increase_hunger
        "Your tamagotchi #{method.to_s.sub($~.to_s, '').downcase}s for a while."
      elsif /^fight/i =~ method
        name = method.to_s.sub($~.to_s + ' ', '')
        target = @@alltamas[name]
        if target.nil?
          return "Your tama has no idea who you want it to fight, so it bites you instead."
        end
        if target.status == 'dead'
          return "What is dead may never die!"
        end
        if (self.strength + rand(1..20)) > (target.strength + rand(1..20))
          2.times do target.increase_hunger end
          2.times do target.increase_sleepiness end
          self.strength += 1
          "Congratulations! Your tama is victorious!   (งಠ_ಠ)ง"
        else
          2.times do increase_hunger; increase_sleepiness end
          "You lose! Dishonor on your family! Dishonor on your cow!   ( ◞•̀д•́)◞⚔️◟(•̀д•́◟ )"
        end
      else
        increase_hunger
        increase_sleepiness
        "Your tamagotchi stares at you with a puzzled expression. \n" + \
        "Available verbs: fight [someone], say [something], do [something] \n" + \
        "Actions: dance, feed, sleep"
      end
    end

    def dance
      increase_hunger
      "♪ ┏(°.°)┛ ┗(°.°)┓ ┗(°.°)┛ ┏(°.°)┓ ♪"
    end

    def feed
      @food_level += 3
      @status = 'awake' if @status == 'hungry'
      'Mmmm, tasty!   ( ˆ ڡ ˆ )'
    end

    def sleep
      @sleep_level = 0
      'Zzz ' * 3
    end

    def increase_hunger
      @food_level -= 1
      if @food_level < 3
        @status = 'hungry'
      end
      if @food_level == 0
        @status = 'dead'
      end
    end

    def increase_sleepiness
      @sleep_level += 1
      if @sleep_level >= 10
        @status = 'sleeping'
      end
    end
  end
end
