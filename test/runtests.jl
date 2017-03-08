using OpenAIGymAPI
using Base.Test

# define helper functions
function get_remote_base(host = "http://127.0.0.1", port = "5000")
  return(host * ":" * port)
end

# setup background server
function setup_background_server()
  @spawn run(detach(`python /tmp/gym-http-api/gym_http_server.py`))
  return(nothing)
end

# teardown background server
function teardown_background_server()
  client = GymClient(get_remote_base())
  shutdown_server(client)
  return(nothing)
end

# define wrapper
function with_server(fn)
  setup_background_server()
  sleep(1) # otherwise API is called before server is fully setup
  fn()
  teardown_background_server()
  return(nothing)
end

########## TESTS ##########

##### Valid use cases #####
function test_create_destroy()
  client = GymClient(get_remote_base())
  instance_id = env_create(client, "CartPole-v0")
  @test haskey(env_list_all(client), instance_id)
  env_close(client, instance_id)
  @test !haskey(env_list_all(client), instance_id)
  return(nothing)
end
with_server(test_create_destroy)

function test_action_space_discrete()
  client = GymClient(get_remote_base())
  instance_id = env_create(client, "CartPole-v0")
  action_info = env_action_space_info(client, instance_id)
  @test action_info["name"] == "Discrete"
  @test action_info["n"] == 2
  return(nothing)
end
with_server(test_action_space_discrete)

function test_action_space_sample()
  client = GymClient(get_remote_base())
  instance_id = env_create(client, "CartPole-v0")
  action = env_action_space_sample(client, instance_id)
  @test 0 <= action < 2
end
with_server(test_action_space_sample)

function test_action_space_contains()
  client = GymClient(get_remote_base())
  instance_id = env_create(client, "CartPole-v0")
  action_info = env_action_space_info(client, instance_id)
  @test action_info["n"] == 2
  @test env_action_space_contains(client, instance_id, 0) == true
  @test env_action_space_contains(client, instance_id, 1) == true
  @test env_action_space_contains(client, instance_id, 2) == false
end
with_server(test_action_space_contains)

# function test_observation_space_box()
#     client = GymClient(get_remote_base())
#     instance_id = env_create("CartPole-v0")
#     obs_info = env_observation_space_info(instance_id)
#     @test obs_info["name"] == "Box"
#     @test len(obs_info["shape"]) == 1
#     @test obs_info["shape"][0] == 4
#     @test len(obs_info["low"]) == 4
#     @test len(obs_info["high"]) == 4
#
#
# function test_reset()
#     client = GymClient(get_remote_base())
#
#     instance_id = env_create("CartPole-v0")
#     init_obs = env_reset(instance_id)
#     @test len(init_obs) == 4
#
#     instance_id = env_create("FrozenLake-v0")
#     init_obs = env_reset(instance_id)
#     @test init_obs == 0
#
#
# function test_step()
#    client = GymClient(get_remote_base())
#
#    instance_id = env_create("CartPole-v0")
#    [observation, reward, done, info] = env_step(instance_id, 0)
#    @test len(observation) == 4
#    @test type(reward) == float
#    @test type(done) == bool
#    @test type(info) == dict
#
#    instance_id = env_create("FrozenLake-v0")
#    [observation, reward, done, info] = env_step(instance_id, 0)
#    @test type(observation) == int
#
#
# function test_monitor_start_close_upload()
#     @test os.environ.get("OPENAI_GYM_API_KEY")
#         # otherwise test is invalid
#
#     client = GymClient(get_remote_base())
#     instance_id = env_create("CartPole-v0")
#     env_monitor_start(instance_id, "tmp", force=true)
#     env_reset(instance_id)
#     env_step(instance_id, 1)
#     env_monitor_close(instance_id)
#     client.upload("tmp")
