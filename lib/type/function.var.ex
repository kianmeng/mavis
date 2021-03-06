defmodule Type.Function.Var do

  @moduledoc """
  a special container type indicating that the function has a type dependency.

  ### Example:

  The following typespec:

  ```elixir
  @spec identity(x) :: x when x: var
  ```

  generates the following typespec:
  ```elixir
  %Type.Function{
    params: [%Type.Function.Var{name: :x}],
    return: %Type.Function.Var{name: :x}
  }
  ```

  if you further put a restriction on this typespec:

  ```elixir
  @spec identity(x) :: x when x: integer
  ```

  the `Type.Function.Var` will further exhibit the issued constraint:

  ```elixir
  %Type.Function{
    params: [%Type.Function.Var{name: :x, constraint: %Type{name: :integer}}],
    return: %Type.Function.Var{name: :x, constraint: %Type{name: :integer}}
  }
  ```
  """

  import Type, only: :macros
  @enforce_keys [:name]
  defstruct @enforce_keys ++ [constraint: builtin(:any)]

  @type t :: %__MODULE__{
    name: atom,
    constraint: Type.t
  }
end

defimpl Inspect, for: Type.Function.Var do
  def inspect(var, _opts) do
    "#{var.name}"
  end
end

defimpl Type.Properties, for: Type.Function.Var do

  alias Type.Function.Var

  def typegroup(%{constraint: constraint}) do
    Type.typegroup(constraint)
  end

  def compare(lhs, rhs = %Var{}) do
    case Type.compare(lhs.constraint, rhs.constraint) do
      comp when comp != :eq -> comp
      :eq -> Type.compare(lhs.name, rhs.name)
    end
  end

  def compare(%{constraint: constraint}, rhs) do
    case Type.compare(constraint, rhs) do
      :eq -> :lt
      comp -> comp
    end
  end

  import Type, only: :macros
  import Type.Helpers

  intersection do
    def intersection(_, %Var{}) do
      raise "can't intersect two var types"
    end

    def intersection(left = %Var{}, right) do
      case Type.intersection(left.constraint, right) do
        builtin(:none) -> builtin(:none)
        type -> %{left | constraint: type}
      end
    end
  end

  subtype do
    def subtype?(left, right = %Var{}) do
      Type.subtype?(left.constraint, right.constraint)
    end
    def subtype?(left = %{}, right) do
      Type.subtype?(left.constraint, right)
    end
  end

  usable_as do
    def usable_as(%Var{}, _right, _meta) do
      raise "unreachable"
    end
  end
end
