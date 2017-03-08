using Requests
import Requests: Response

type GymClient
  remote_base::String
end

function env_list_all(client::GymClient)
  route = "/v1/envs/"
  data = Dict()
  response = get_request(client, route, data)
  all_envs = response["all_envs"]
  return(all_envs)
end

function env_create(client::GymClient, env_id::String)
  route = "/v1/envs/"
  data = Dict("env_id"=>env_id)
  response = post_request(client, route, data)
  instance_id = response["instance_id"]
  return(instance_id)
end

function env_reset(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/reset/"
  data = Dict()
  response = post_request(client, route, data)
  observation = response["observation"]
  return(observation)
end

function env_step(client::GymClient, instance_id::String, action::Number;
                  render::Bool = false)
  route = "/v1/envs/" * instance_id * "/step/"
  data = Dict("instance_id"=>instance_id, "action"=>action, "render"=>render)
  response = post_request(client, route, data)
  observation = response["observation"]
  reward = response["reward"]
  done = response["done"]
  info = response["info"]
  result = Dict("observation"=>observation, "reward"=>reward,
                "done"=>done, "info"=>info)
  return(result)
end

function env_action_space_info(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/action_space/"
  data = Dict()
  response = get_request(client, route, data)
  info = response["info"]
  return(info)
end

function env_action_space_sample(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/action_space/sample"
  data = Dict()
  response = get_request(client, route, data)
  action = response["action"]
  return(action)
end

function env_action_space_contains(client::GymClient, instance_id::String,
                                   action::Number)
  route = "/v1/envs/" * instance_id *  "/action_space/contains/"
  route = route * string(action)
  data = Dict()
  response = get_request(client, route, data)
  member = response["member"]
  return(member)
end

function env_observation_space_info(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/observation_space/"
  data = Dict()
  response = get_request(client, route, data)
  info = response["info"]
  return(info)
end

function env_monitor_start(client::GymClient, instance_id::String,
                           directory::String; force::Bool = false,
                           resume::Bool = false)
  route = "/v1/envs/" * instance_id * "/monitor/start/"
  data = Dict("directory"=>directory, "force"=>force,
              "resume"=>resume)
  response = post_request(client, route, data)
  return(nothing)
end

function env_monitor_close(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/monitor/close/"
  data = Dict()
  response = post_request(client, route, data)
  return(nothing)
end

function env_close(client::GymClient, instance_id::String)
  route = "/v1/envs/" * instance_id * "/close/"
  data = Dict()
  response = post_request(client, route, data)
  return(nothing)
end

function upload(client::GymClient, training_dir::String,
                api_key::String, algorithm_id::String)
  # if (is.null(api_key))
  #   api_key = Sys.getenv("OPENAI_GYM_API_KEY")
  # end
  route = "/v1/upload/"
  data = Dict("training_dir"=>training_dir, "algorithm_id"=>algorithm_id,
              "api_key"=>api_key)
  response = post_request(client, route, data)
  return(nothing)
end

function shutdown_server(client::GymClient)
  route = "/v1/shutdown/"
  data = Dict()
  response = post_request(client, route, data)
  return(nothing)
end
