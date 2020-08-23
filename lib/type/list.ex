defmodule Type.List do
  defstruct [
    nonempty: false,
    type: %Type{name: :any},
    final: []
  ]

  @type t :: %__MODULE__{
    nonempty: boolean,
    type: Type.t,
    final: Type.t
  }

  defimpl Type.Typed do
    import Type, only: :macros

    def coercion(_, builtin(:any)), do: :type_ok
    def coercion(%{nonempty: false}, []), do: :type_maybe
    def coercion(lst_src = %Type.List{}, lst_dst = %Type.List{}) do
      Type.List.compare(lst_src, lst_dst)
    end
    def coercion(_, _), do: :type_error
  end

  def compare(%{type: body_1, final: final_1, nonempty: ne1},
              %{type: body_2, final: final_2, nonempty: ne2}) do
    case {Type.coercion(body_1, body_2), Type.coercion(final_1, final_2)} do
      {:type_ok, :type_ok} -> :type_ok
      {:type_error, _} -> :type_error
      {_, :type_error} -> :type_error
      {:type_maybe, _} -> :type_maybe
      {_, :type_maybe} -> :type_maybe
    end
    |> ok_to_maybe(ne1, ne2)
  end

  defp ok_to_maybe(:type_ok, false, true), do: :type_maybe
  defp ok_to_maybe(any, _, _), do: any

end
