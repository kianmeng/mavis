defmodule TypeTest.Builtin.SubtypeTest do
  use ExUnit.Case, async: true

  @moduletag :subtype

  import Type, only: [builtin: 1]

  use Type.Operators

  describe "builtin none" do
    test "is a subtype of itself" do
      assert builtin(:none) in builtin(:none)
    end

    test "is not a subtype of any" do
      refute builtin(:none) in builtin(:any)
    end

    test "is a subtype of a union with itself" do
      assert builtin(:none) in (builtin(:none) <|> builtin(:integer))
    end

    test "is not a subtype of all types" do
      TypeTest.Targets.except()
      |> Enum.each(fn target ->
        refute builtin(:none) in target
      end)
    end
  end

  describe "builtin neg_integer" do
    test "is a subtype of itself" do
      assert builtin(:neg_integer) in builtin(:neg_integer)
    end

    test "is a subtype of integer and any" do
      assert builtin(:neg_integer) in builtin(:integer)
      assert builtin(:neg_integer) in builtin(:any)
    end

    test "is a subtype of unions with itself and integer" do
      assert builtin(:neg_integer) in (builtin(:neg_integer) <|> builtin(:atom))
      assert builtin(:neg_integer) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:neg_integer) in (builtin(:pid) <|> builtin(:atom))
      refute builtin(:neg_integer) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all types" do
      TypeTest.Targets.except([builtin(:neg_integer), builtin(:integer)])
      |> Enum.each(fn target ->
        refute builtin(:neg_integer) in target
      end)
    end
  end

  describe "builtin pos_integer" do
    test "is a subtype of itself" do
      assert builtin(:pos_integer) in builtin(:pos_integer)
    end

    test "is a subtype of integer and any" do
      assert builtin(:pos_integer) in builtin(:non_neg_integer)
      assert builtin(:pos_integer) in builtin(:integer)
      assert builtin(:pos_integer) in builtin(:any)
    end

    test "is a subtype of unions with itself and integer" do
      assert builtin(:pos_integer) in (builtin(:pos_integer) <|> builtin(:atom))
      assert builtin(:pos_integer) in (builtin(:non_neg_integer) <|> builtin(:atom))
      assert builtin(:pos_integer) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:pos_integer) in (builtin(:pid) <|> builtin(:atom))
      refute builtin(:pos_integer) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all types" do
      TypeTest.Targets.except([builtin(:pos_integer), builtin(:non_neg_integer), builtin(:integer)])
      |> Enum.each(fn target ->
        refute builtin(:pos_integer) in target
      end)
    end
  end

  describe "builtin non_neg_integer" do
    test "is a subtype of itself" do
      assert builtin(:non_neg_integer) in builtin(:non_neg_integer)
    end

    test "is a subtype of integer and any" do
      assert builtin(:non_neg_integer) in builtin(:integer)
      assert builtin(:non_neg_integer) in builtin(:any)
    end

    test "is a subtype of unions with itself and integer" do
      assert builtin(:non_neg_integer) in (builtin(:non_neg_integer) <|> builtin(:atom))
      assert builtin(:non_neg_integer) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:non_neg_integer) in (builtin(:pid) <|> builtin(:atom))
      refute builtin(:non_neg_integer) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all types" do
      TypeTest.Targets.except([builtin(:non_neg_integer), builtin(:integer)])
      |> Enum.each(fn target ->
        refute builtin(:non_neg_integer) in target
      end)
    end
  end

  describe "builtin integer" do
    test "is a subtype of itself" do
      assert builtin(:integer) in builtin(:integer)
    end

    test "is a subtype of integer and any" do
      assert builtin(:integer) in builtin(:integer)
      assert builtin(:integer) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:integer) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:integer) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:integer)])
      |> Enum.each(fn target ->
        refute builtin(:integer) in target
      end)
    end
  end

  describe "builtin float" do
    test "is a subtype of itself and any" do
      assert builtin(:float) in builtin(:float)
      assert builtin(:float) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:float) in (builtin(:float) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:float) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:float)])
      |> Enum.each(fn target ->
        refute builtin(:float) in target
      end)
    end
  end

  describe "builtin node" do
    test "is a subtype of itself, atom, and any" do
      assert builtin(:node) in builtin(:node)
      assert builtin(:node) in builtin(:atom)
      assert builtin(:node) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:node) in (builtin(:integer) <|> builtin(:node))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:node) in (builtin(:pid) <|> builtin(:integer))
    end
  end

  describe "builtin module" do
    test "is a subtype of itself, atom, and any" do
      assert builtin(:module) in builtin(:module)
      assert builtin(:module) in builtin(:atom)
      assert builtin(:module) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:module) in (builtin(:integer) <|> builtin(:module))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:module) in (builtin(:pid) <|> builtin(:integer))
    end
  end

  describe "builtin atom" do
    test "is a subtype of itself and any" do
      assert builtin(:atom) in builtin(:atom)
      assert builtin(:atom) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:atom) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:atom) in (builtin(:pid) <|> builtin(:integer))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:atom)])
      |> Enum.each(fn target ->
        refute builtin(:atom) in target
      end)
    end
  end

  describe "builtin reference" do
    test "is a subtype of itself ati aty" do
      assert builtin(:reference) in builtin(:reference)
      assert builtin(:reference) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:reference) in (builtin(:reference) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:reference) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:reference)])
      |> Enum.each(fn target ->
        refute builtin(:reference) in target
      end)
    end
  end

  describe "builtin port" do
    test "is a subtype of itself and any" do
      assert builtin(:port) in builtin(:port)
      assert builtin(:port) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:port) in (builtin(:port) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:port) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:port)])
      |> Enum.each(fn target ->
        refute builtin(:port) in target
      end)
    end
  end

  describe "builtin pid" do
    test "is a subtype of itself and any" do
      assert builtin(:pid) in builtin(:pid)
      assert builtin(:pid) in builtin(:any)
    end

    test "is a subtype of unions with itself" do
      assert builtin(:pid) in (builtin(:pid) <|> builtin(:atom))
    end

    test "is not a subtype of orthogonal unions" do
      refute builtin(:pid) in (builtin(:integer) <|> builtin(:atom))
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:pid)])
      |> Enum.each(fn target ->
        refute builtin(:pid) in target
      end)
    end
  end

  describe "builtin any" do
    test "is a subtype of itself" do
      assert builtin(:any) in builtin(:any)
    end

    test "is not a subtype of all other types" do
      TypeTest.Targets.except([builtin(:any)])
      |> Enum.each(fn target ->
        refute builtin(:any) in target
      end)
    end
  end
end
