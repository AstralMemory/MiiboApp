extends Control

var mes = ""
var http_request = HTTPRequest.new() 
var data
var headers = ["Content-Type: application/json"]

func _ready():
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	add_child(http_request)
	data = {
		"api_key" : Config.api_key,
		"agent_id" : Config.agent_id,
		"utterance" : ""
	}
	if Config.api_key == null or Config.api_url == null or Config.agent_id == null:
		$Alert.popup_centered()
	
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var test_json_conv = JSON.new()
		test_json_conv.parse_string(body.get_string_from_utf8()).result
		var json = test_json_conv.get_data()
		var bestResponse = json["bestResponse"]
		var getMes = bestResponse["utterance"]
		$Response.text = $Response.text + "AI:" + getMes + "\n"
		



func _on_Send_pressed():
	$Response.text = $Response.text + "You:" + $Prompt.text + "\n"
	data["utterance"] = $Prompt.text
	var body = JSON.stringify(data)
	http_request.request(Config.api_url, headers, HTTPClient.METHOD_POST, body)
	$Prompt.text = ""


func _on_Alert_confirmed():
	get_tree().quit()
