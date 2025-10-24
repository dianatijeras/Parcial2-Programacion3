defmodule Ejercicio4 do
  @moduledoc """
  Eliminar duplicados por código, preservando el primer orden de aparición
  Implementación RECURSIVA sin usar Enum
  """

 alias Ejercicio1.Pieza

  def eliminar([]), do: []
  def eliminar([%Pieza{codigo: c} = p | resto]) do
    if existe?(resto, c) do
      [p | eliminar(filtrar_codigo(resto, c))]
    else
      [p | eliminar(resto)]
    end
  end

  # Verifica si un código ya está más adelante
  defp existe?([], _), do: false
  defp existe?([%Pieza{codigo: c} | _], c), do: true
  defp existe?([_ | t], c), do: existe?(t, c)

  # Elimina las piezas con el mismo código repetido
  defp filtrar_codigo([], _), do: []
  defp filtrar_codigo([%Pieza{codigo: c} | t], c), do: filtrar_codigo(t, c)
  defp filtrar_codigo([h | t], c), do: [h | filtrar_codigo(t, c)]
end
