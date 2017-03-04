module OpenAIGymAPI

export
  GymClient,
  env_list_all,
  env_create,
  env_reset,
  env_step,
  env_action_space_info,
  env_action_space_sample,
  env_action_space_contains,
  env_observation_space_info,
  env_monitor_start,
  env_monitor_close,
  env_close,
  upload,
  shutdown_server,
  parse_server_error_or_raise_for_status,
  get_request,
  post_request

include("api.jl")
include("utils.jl")

end # module OpenAIGymAPI
