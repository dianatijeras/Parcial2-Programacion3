defmodule Inventario do
  # Total de unidades movidas en rango de fechas
  def total_en_rango([], _fini, _ffin), do: 0
  def total_en_rango([%Movimiento{fecha: f, cantidad: c} | resto], fini, ffin) do
    if f >= fini and f <= ffin do
      c + total_en_rango(resto, fini, ffin)
    else
      total_en_rango(resto, fini, ffin)
    end
  end

  # Eliminar duplicados por código (preservando orden)
  def eliminar_duplicados([]), do: []
  def eliminar_duplicados([%Pieza{codigo: c} = p | resto]) do
    if existe?(resto, c) do
      [p | eliminar_duplicados(filtrar_codigo(resto, c))]
    else
      [p | eliminar_duplicados(resto)]
    end
  end

  defp existe?([], _), do: false
  defp existe?([%Pieza{codigo: c} | _], c), do: true
  defp existe?([_ | t], c), do: existe?(t, c)

  defp filtrar_codigo([], _), do: []
  defp filtrar_codigo([%Pieza{codigo: c} | t], c), do: filtrar_codigo(t, c)
  defp filtrar_codigo([h | t], c), do: [h | filtrar_codigo(t, c)]
end
