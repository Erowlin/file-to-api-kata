require 'rack'
require 'json'

class FileApi
	def initialize
		file = File.read('./data.json')
		@thomas_table = JSON.parse(file)
		@routes_hash = {
			['GET', /^\/movies\/(?<id>\d+)$/] => :movies_get
		}
	end

	def call env
		p env
    match = nil
		res = @routes_hash.find do |k, v|
		  match = env['REQUEST_PATH'].match k[1]
		  env['REQUEST_METHOD'] == k[0] && match
		end
		if res.nil?
			handler = :not_found
		else
		  handler = res[1]
		end
		status, body = send(handler, match)
 		body = JSON.pretty_generate(body) rescue body
		[status, {'Content-Type' => 'application/json'}, [body.to_s] ]
	end

	def not_found params=nil
		['404', "Bah non... :D"]
	end

	## Movies routes
	def movies_index params

	end

	def movies_get params
		body = @thomas_table['movies'].find { |m| m['id'].to_s == params[:id] }
		body.nil? ? not_found : ['200', body]
	end

	def movies_put

	end

	def movies_post

	end

	## Directors routes
	def directors_index

	end

	def directors_get

	end

	def directors_put

	end

	def directors_post

	end
end

# app = Proc.new do |env|
#     ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
# end

Rack::Handler::WEBrick.run FileApi.new

