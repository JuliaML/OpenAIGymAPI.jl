using OpenAIGymAPI
using Base.Test

# define helper functions
function get_remote_base(host = "http://127.0.0.1", port = "5000")
  return(host * ":" * port)
end

# set server up
# to be edited

# tear server down
# to be edited

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

test_create_destroy()
