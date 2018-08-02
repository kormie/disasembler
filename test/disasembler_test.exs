defmodule DisasemblerTest do
  use ExUnit.Case
  doctest Disasembler

  test "greets the world" do
    assert Disasembler.hello() == :world
  end
end
