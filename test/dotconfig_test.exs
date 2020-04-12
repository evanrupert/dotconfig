defmodule DotconfigTest do
  use ExUnit.Case
  doctest Dotconfig

  test "greets the world" do
    assert Dotconfig.hello() == :world
  end
end
