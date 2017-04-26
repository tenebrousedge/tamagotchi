require 'tama/version'
require 'tama/monster'

module Tama
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
      tama.status = 'still sleeping'
      "ssh, #{tama.name} is sleeping"
    elsif tama.status == 'still sleeping'
      tama.status = 'waking up'
    elsif tama.status == 'waking up'
      tama.status = 'awake'
      tama.send(method)
    elsif tama.status == 'awake' || tama.status == 'hungry'
      tama.send(method)
    elsif tama.status == 'dead'
      "Sorry, this tamagotchi died :("
    end
  end
end
