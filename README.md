# OpenAIGymAPI.jl

_Wrapper for the [OpenAI Gym API](https://github.com/openai/gym-http-api)._

| **Package Status** | **Package Evaluator** | **Build Status**  |
|:------------------:|:---------------------:|:-----------------:|
| [![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) |  [![OpenAIGymAPI](http://pkg.julialang.org/badges/OpenAIGymAPI_0.5.svg)](http://pkg.julialang.org/?pkg=OpenAIGymAPI&ver=0.5) [![OpenAIGymAPI](http://pkg.julialang.org/badges/OpenAIGymAPI_0.6.svg)](http://pkg.julialang.org/?pkg=OpenAIGymAPI&ver=0.6) | [![Build Status](https://travis-ci.org/paulhendricks/OpenAIGymAPI.jl.svg?branch=master)](https://travis-ci.org/paulhendricks/OpenAIGymAPI.jl) [![Build status](https://ci.appveyor.com/api/projects/status/?svg=true)](https://ci.appveyor.com/project/paulhendricks/OpenAIGymAPI-jl) [![Coverage Status](https://coveralls.io/repos/paulhendricks/OpenAIGymAPI.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/paulhendricks/OpenAIGymAPI.jl?branch=master) |

## Introduction

[OpenAI Gym](https://github.com/openai/gym) is a open-source Python toolkit for developing and comparing reinforcement learning algorithms. This Julia package is a wrapper for the [OpenAI Gym API](https://github.com/openai/gym-http-api), and enables access to an ever-growing variety of environments.

Installation
------------

This package is registered in `METADATA.jl` and can be installed as usual

``` julia
Pkg.add("OpenAIGymAPI")
using OpenAIGymAPI
```

If you encounter a clear bug, please file a minimal reproducible example on [Github](https://github.com/paulhendricks/OpenAIGymAPI.jl/issues).

## Setting up the server

To download the code and install the requirements, you can run the following shell commands:

``` bash
git clone https://github.com/openai/gym-http-api
cd gym-http-api
pip install -r requirements.txt
```

This code is intended to be run locally by a single user. The server runs in python.

To start the server from the command line, run this:

``` bash
python gym_http_server.py
```

For more details, please see here: <https://github.com/openai/gym-http-api>.

## Overview

``` julia
using OpenAIGymAPI

remote_base = "http://127.0.0.1:5000"
client = GymClient(remote_base)
print(client)

# Create environment
env_id = "CartPole-v0"
instance_id = env_create(client, env_id)
print(instance_id)

# List all environments
all_envs = env_list_all(client)
print(all_envs)

# Set up agent
action_space_info = env_action_space_info(client, instance_id)
print(action_space_info)
agent = action_space_info["n"] # perform same action every time

# Run experiment, with monitor
outdir = "/tmp/random-agent-results"
env_monitor_start(client, instance_id, outdir, force = true, resume = false)

episode_count = 100
max_steps = 200
for i in 1:episode_count
  ob = env_reset(client, instance_id)
  done = false
  j = 1
  while j <= 200 && !done
    action = env_action_space_sample(client, instance_id)
    results = env_step(client, instance_id, action, render = true)
    done = results["done"]
    j = j + 1
  end
end

# Dump result info to disk
env_monitor_close(client, instance_id)
```

## License

This code is free to use under the terms of the MIT license.

## Acknowledgements

The original author of `OpenAIGymAPI` is [@Paul Hendricks](<https://github.com/paulhendricks>). [![Gratipay](https://img.shields.io/gratipay/JSFiddle.svg)](https://gratipay.com/~paulhendricks/)
