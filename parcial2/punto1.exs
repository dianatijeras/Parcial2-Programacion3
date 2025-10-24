def module Ejercicio1 do
  @moduledoc """
  Lestura de archivos CSV de piezas y conteo recursivo
  """
  defmodule Pieza do
    defstruct [:codigo, :nombre, :valor, :unidad, :stock]
  end

  def leer_piezas (archivo) do
    case File.read(archivo) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        {:ok, parsear_lineas(lineas)}

        {:error, razon} ->
          {:error, "No se pudo leer el archivo: #{razon}"}
    end
  end

  # Función recursiva para convertir las líneas en structs Pieza
  defp parsear_lineas([]), do: []
  defp parsear_lineas([linea | resto]) do
    case String.split(linea, ",") do
      [cod, nombre, valor, unidad, stock] ->
        pieza = %Pieza{
          codigo: String.trim(cod),
          nombre: String.trim(nombre),
          valor: String.to_integer(String.trim(valor)),
          unidad: String.trim(unidad),
          stock: String.to_integer(String.trim(stock))
        }

        [pieza | parsear_lineas(resto)]

      _ ->
        IO.puts("Línea inválida: #{linea}")
        parsear_lineas(resto)
    end
  end



  #PARTE B: contar piezas con stock < t (RECURSIVO)
  def contar_bajo_stock([], _t), do: 0
  def contar_bajo_stock([%Pieza{stock: s} | resto], t) when s < t do
    1 + contar_bajo_stock(resto, t)
  end
  def contar_bajo_stock([_ | resto], t), do: contar_bajo_stock(resto, t)
end
