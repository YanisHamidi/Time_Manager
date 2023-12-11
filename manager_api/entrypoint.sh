#!/bin/bash

mix deps.get
mix ecto.setup
exec mix phx.server