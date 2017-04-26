require 'sinatra'
require 'pry'
require './lib/tama'

if development?
  require 'sinatra/reloader'
  also_reload('**/*.rb')
end

get('/') do
  @tamas = Tama.get_tamas
  erb(:index)
end

get('/new_tama') do
  @name = params.fetch('new.name')
  Tama.new_tama(@name)
  @tamas = Tama.get_tamas
  erb(:index)
end

get('/tama_do') do
  # binding.pry
  @name = params.fetch('tama.name')
  @method = params.fetch('method')
  @result = {}
  @result[@name] = Tama.tama_action(@method, Tama.get_tamas(@name))
  @tamas = Tama.get_tamas
  erb(:index)
end
