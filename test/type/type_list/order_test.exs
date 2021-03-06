defmodule TypeTest.TypeList.OrderTest do
  use ExUnit.Case, async: true

  @moduletag :compare

  import Type, only: [builtin: 1]

  use Type.Operators

  alias Type.List

  defp nonempty(terms) do
    List
    |> struct(terms)
    |> Map.put(:nonempty, true)
  end

  describe "a nonempty true list" do
    test "is bigger than bottom and reference" do
      assert nonempty(type: builtin(:any)) > builtin(:none)
      assert nonempty(type: builtin(:any)) > builtin(:reference)
    end

    test "is bigger than a list which is a subclass" do
      assert nonempty(type: builtin(:any)) > nonempty(type: builtin(:integer))
      # because the final is more general
      assert nonempty(type: builtin(:any), final: builtin(:any)) >
        nonempty(type: builtin(:any))
    end

    test "is smaller than a list which is a superclass" do
      assert nonempty(type: builtin(:integer)) < nonempty(type: builtin(:any))
      assert nonempty(type: builtin(:integer)) < %List{type: builtin(:integer)}
      # because the final is more general
      assert nonempty(type: builtin(:any)) <
        nonempty(type: builtin(:any), final: builtin(:any))
    end

    test "is smaller than maybe-empty lists, empty list, bitstrings or top" do
      assert nonempty(type: builtin(:any)) < []
      assert nonempty(type: builtin(:any)) < %List{type: builtin(:integer)}
      assert nonempty(type: builtin(:any)) < %Type.Bitstring{size: 0, unit: 0}
      assert nonempty(type: builtin(:any)) < builtin(:any)
    end
  end

  describe "a nonempty false list" do
    test "is bigger than bottom and reference, and empty list" do
      assert %List{type: builtin(:any)} > builtin(:none)
      assert %List{type: builtin(:any)} > builtin(:reference)
      assert %List{type: builtin(:any)} > []
    end

    test "is bigger than a list which is nonempty: true" do
      assert %List{type: builtin(:integer)} > nonempty(type: builtin(:any))
    end

    test "is bigger than a list which is a subclass" do
      assert %List{type: builtin(:any)} > %List{type: builtin(:integer)}
      # because the final is more general
      assert %List{type: builtin(:any), final: builtin(:any)} >
        %List{type: builtin(:any)}
    end

    test "is smaller than a union containing it" do
      assert  %List{type: builtin(:any)} < nil <|>  %List{type: builtin(:any)}
    end

    test "is smaller than a list which is a superclass" do
      assert %List{type: builtin(:integer)} < %List{type: builtin(:any)}
      # because the final is more general
      assert %List{type: builtin(:any)} <
        %List{type: builtin(:any), final: builtin(:any)}
    end

    test "is smaller than maybe-empty lists, bitstrings or top" do
      assert %List{type: builtin(:any)} < %Type.Bitstring{size: 0, unit: 0}
      assert %List{type: builtin(:any)} < builtin(:any)
    end
  end

end
