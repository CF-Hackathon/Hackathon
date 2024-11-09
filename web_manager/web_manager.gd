extends Node

signal request_completed

const URL = "https://gr6ymr51ug.execute-api.us-east-1.amazonaws.com/Prod/uri"

var request: HTTPRequest
var response_code: int
var body: PoolByteArray
var request_error = OK
var presigned_url: String
func save_world(data):
	pass

func upload_world(buffer):
	var json_data = {
		"object_name": "test_hackatong/test.json",
		"content_type": "application/octet-stream"
	}
	
	var json_string = JSON.print(json_data)
	request = create_request()
	#request.request(URL, [], HTTPClient.METHOD_PUT, json_string)
	request.request(URL, [], true, HTTPClient.METHOD_PUT, json_string)
	
	yield(request, "request_completed")
	if presigned_url != "":
		#var json_save_data = JSON.print(data)
		#var data_len = data.get_len()
		#print(data_len)
		#var buffer = data.get_buffer(data_len)
		#print(buffer)
		#json_save_data.
		print("saving")
		var headers = ["Content-Type: application/octet-stream"]
		request.request_raw(presigned_url, headers, true, HTTPClient.METHOD_PUT, buffer)
		#request.request(URL, [], HTTPClient.METHOD_PUT, json_save_data)
		#request.request(presigned_url, [], true, HTTPClient.METHOD_PUT, json_save_data)



func download_file(object_name: String, file_path: String):
	var buffer = yield(download_buffer(object_name), "completed")
	if buffer.is_empty(): 
		print("Couldn't download buffer for file download.")
		return FAILED
	
	
	# store file
	var file = File.new()
	var error = file.open(file_path, File.WRITE)
	if error: 
		print("opening file "+ file_path + " failed: ")
		return error
	file.store_buffer(buffer)
	file.close()
	print("downloaded file to " + file_path)
	return OK

func download_buffer(object_name: String) -> PoolByteArray:
	# get url for downloading
	var path = str(URL + "?folder_name=" + object_name)
	
	request = create_request()
	print("full path: ", str(URL + "?object_name=" + object_name))
	request.request(URL + "?object_name=" + object_name)
	
	yield(request, "request_completed")
	
	if request_error: return PoolByteArray()
	
	var dict = JSON.parse_string(body.get_string_from_utf8())
	
	# get file from url
	request = create_request()
	#print("token: ", dict["url"])
	request.request(dict["url"])
	yield(request, "request_completed")
	if request_error: return PoolByteArray()
	return body

func create_request() -> HTTPRequest:
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", self, "_on_http_request_completed")
	return request

func _on_http_request_completed(result, response_code, headers, body):
	self.response_code = response_code
	self.body = body
	var response = parse_json(body.get_string_from_utf8())
	print(response)
	print(response_code)
	if response != null:
		if response.has("url"):
			presigned_url = response["url"]
	request_error = OK if response_code == 200 else FAILED
	emit_signal("request_completed")