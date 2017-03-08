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
  sleep(3)
  fn()
  sleep(3)
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

# @with_server
# function test_action_space_sample():
#     client = gym_http_client.Client(get_remote_base())
#     instance_id = client.env_create('CartPole-v0')
#     action = client.env_action_space_sample(instance_id)
#     assert 0 <= action < 2
#
# @with_server
# function test_action_space_contains():
#     client = gym_http_client.Client(get_remote_base())
#     instance_id = client.env_create('CartPole-v0')
#     action_info = client.env_action_space_info(instance_id)
#     assert action_info['n'] == 2
#     assert client.env_action_space_contains(instance_id, 0) == True
#     assert client.env_action_space_contains(instance_id, 1) == True
#     assert client.env_action_space_contains(instance_id, 2) == False
#
# @with_server
# function test_observation_space_box():
#     client = gym_http_client.Client(get_remote_base())
#     instance_id = client.env_create('CartPole-v0')
#     obs_info = client.env_observation_space_info(instance_id)
#     assert obs_info['name'] == 'Box'
#     assert len(obs_info['shape']) == 1
#     assert obs_info['shape'][0] == 4
#     assert len(obs_info['low']) == 4
#     assert len(obs_info['high']) == 4
#
# @with_server
# function test_reset():
#     client = gym_http_client.Client(get_remote_base())
#
#     instance_id = client.env_create('CartPole-v0')
#     init_obs = client.env_reset(instance_id)
#     assert len(init_obs) == 4
#
#     instance_id = client.env_create('FrozenLake-v0')
#     init_obs = client.env_reset(instance_id)
#     assert init_obs == 0
#
# @with_server
# function test_step():
#    client = gym_http_client.Client(get_remote_base())
#
#    instance_id = client.env_create('CartPole-v0')
#    [observation, reward, done, info] = client.env_step(instance_id, 0)
#    assert len(observation) == 4
#    assert type(reward) == float
#    assert type(done) == bool
#    assert type(info) == dict
#
#    instance_id = client.env_create('FrozenLake-v0')
#    [observation, reward, done, info] = client.env_step(instance_id, 0)
#    assert type(observation) == int
#
# @with_server
# function test_monitor_start_close_upload():
#     assert os.environ.get('OPENAI_GYM_API_KEY')
#         # otherwise test is invalid
#
#     client = gym_http_client.Client(get_remote_base())
#     instance_id = client.env_create('CartPole-v0')
#     client.env_monitor_start(instance_id, 'tmp', force=True)
#     client.env_reset(instance_id)
#     client.env_step(instance_id, 1)
#     client.env_monitor_close(instance_id)
#     client.upload('tmp')
