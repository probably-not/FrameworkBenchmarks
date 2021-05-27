defmodule StarshipTest do
  use ExUnit.Case
  doctest Starship

  test "greets the world" do
    assert Starship.hello() == :world
  end
end
