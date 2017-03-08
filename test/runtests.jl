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
