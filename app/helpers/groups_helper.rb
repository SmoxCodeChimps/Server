module GroupsHelper
	require 'time'
	require 'net/http'
	require 'base64'
	require 'openssl'
	require 'httparty'

	def send_post(group)
		date = Time.now.httpdate
		post_verb = "POST"
		content_type = "application/json"
		path = 'https://vws.vuforia.com/targets'
		uri = URI(path)
		image = group.tracker.download

		puts image.class.name

		request = Net::HTTP::Post.new(uri)
		request.body={
		  "name" => "#{group.tracker_name}",
		  "width" => 50.0,
		  "image" => Base64.encode64(image),
		  "application_metadata" => Base64.encode64("benis")

		}.to_json

		content_MD5 = OpenSSL::Digest::MD5.hexdigest(request.body).downcase

		to_sign = string_to_sign(date,post_verb,content_MD5,content_type,path)
		authorization = "VWS " + "08f9b536af86311892f352952f53ce36d8f6cbad"+ ":"+to_sign

		request['Date'] = date
		request['Content-Type'] = content_type
		request['Authorization'] = authorization

		return request
	end

	def send_update(group)
		date = Time.now.httpdate
		post_verb = "PUT"
		content_type = "application/json"
		path = 'https://vws.vuforia.com/targets/'+group.tracker_id
		image = group.tracker.download
		subpath = "/targets/"+group.tracker_id

		body= {
		  "name" => "#{group.tracker_name}",
		  "width" => 50.0,
		  "image" => Base64.encode64(image),
		  "application_metadata" => Base64.encode64("benis")

		}.to_json
		content_MD5 = OpenSSL::Digest::MD5.hexdigest(body).downcase

		to_sign = string_to_sign(date,post_verb,content_MD5,content_type,subpath)
		authorization = "VWS " + "08f9b536af86311892f352952f53ce36d8f6cbad"+ ":"+to_sign

		request = HTTParty.put(path, 
	    :body => body,
	    :headers => { 'Content-Type' => content_type, 'Date' => date, 'Authorization' => authorization},
	    :debug_output => $stdout)
	end

	def party_post(group)
		date = Time.now.httpdate
		post_verb = "POST"
		content_type = "application/json"
		path = 'https://vws.vuforia.com/targets'
		image = group.tracker.download
		subpath = "/targets"

		body= {
		  "name" => "#{group.tracker_name}",
		  "width" => 50.0,
		  "image" => Base64.encode64(image),
		  "application_metadata" => Base64.encode64("benis")

		}.to_json
		content_MD5 = OpenSSL::Digest::MD5.hexdigest(body).downcase

		to_sign = string_to_sign(date,post_verb,content_MD5,content_type,subpath)
		authorization = "VWS " + "08f9b536af86311892f352952f53ce36d8f6cbad"+ ":"+to_sign

		request = HTTParty.post(path, 
	    :body => body,
	    :headers => { 'Content-Type' => content_type, 'Date' => date, 'Authorization' => authorization},
	    :debug_output => $stdout)

	end


	def party_get()
		date = Time.now.httpdate
		get_verb = "GET"
		content_type = ""
		path = "https://vws.vuforia.com/targets/f8040053d8274fc1898b5300100d61f4"
		content_MD5 = "d41d8cd98f00b204e9800998ecf8427e"
		to_sign = string_to_sign(date,get_verb,content_MD5,content_type,"/targets/f8040053d8274fc1898b5300100d61f4")
		authorization = "VWS " + "08f9b536af86311892f352952f53ce36d8f6cbad"+ ":"+to_sign
		request = HTTParty.get(path, 
	    :headers => { 'Date' => date, 'Authorization' => authorization},
	    :debug_output => $stdout)

	end


	def string_to_sign(date,verb,md5,content_type,path)
		data = verb + "\n" +md5 + "\n" +
 			content_type + "\n" +
  			date + "\n" + path;
  		digest = OpenSSL::Digest.new('sha1')
  		key = "6ed8e3d03c83cb9818fac1dde18597dbfbf5aa10"

		hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, key, data))
		return hmac
	end
end
