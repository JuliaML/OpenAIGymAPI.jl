using Requests
import Requests: Response

function parse_server_error_or_raise_for_status(response::Response)
  if response.status == 204
    response = nothing
  elseif response.status == 200
    try
      response = Requests.json(response)
    catch
      response = nothing
    end
  else
    error("Error! Bad status code: " * string(response.status))
  end
  return(response)
end

function get_request(client::GymClient, route::String, data::Dict)
  response = get(client.remote_base * route, json = data)
  response = parse_server_error_or_raise_for_status(response)
  return(response)
end

function post_request(client::GymClient, route::String, data::Dict)
  response = post(client.remote_base * route, json = data)
  response = parse_server_error_or_raise_for_status(response)
  return(response)
end
