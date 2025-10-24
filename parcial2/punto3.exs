defmodule Ejercicio3 do
  @moduledoc """
  Calcular total de unidades movidas en un rango de fechas (RECURSIVO)
  """

  alias Ejercicio2.Movimiento

  def total_en_rango([], _fini, _ffin), do: 0
  def total_en_rango([%Movimiento{fecha: f, cantidad: c} | resto], fini, ffin) do
    if f >= fini and f <= ffin do
      c + total_en_rango(resto, fini, ffin)
    else
      total_en_rango(resto, fini, ffin)
    end
  end

end
