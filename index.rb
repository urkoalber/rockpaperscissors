require 'sinatra'
require 'erb'

before do
	content_type :html
	@defeat = {:rock => :paper,
		:paper => :scissors,
		:scissors => :rock }
	@throws = @defeat.keys
end

get '/' do
	$player_counter ||= 0
	$comp_counter ||= 0
	# llamamos a la plantilla de seleccion
	# ¿que jugada quiere realizar? ... etc
	# una vez seleccionado la jugada, se llama a la plagina de jugar. Ej: elegimos tijeras --> llamamos a /throw/scissors
	haml :indexhtml
	
end

get '/reset' do
	$player_counter = 0
	$comp_counter = 0
	redirect '/'
end

get '/throw/' do
	redirect '/'
end

get '/throw/:type' do
	selection = :type.downcase
	player_throw = params[selection].to_sym
	halt 403, "You must throw one of the following: #{@throws}" unless @throws.include? player_throw
	computer_throw = @throws.sample
	@you_play = player_throw
	@comp_plays = computer_throw
	if player_throw == computer_throw
		@answer = "You tied with the computer. Try again"
	elsif computer_throw == @defeat[player_throw]
		@answer = "Computer wins!"
		$comp_counter += 1
	else
		@answer = "You win!"
		$player_counter += 1		
	end
	erb :resulthtml
end

