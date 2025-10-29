defmodule Pieza do
  defstruct [:codigo, :nombre, :valor, :unidad, :stock]

  # Crear archivo CSV con piezas de ejemplo
  def crear_archivo_ejemplo(path) do
    contenido = """
    COD123,Resistor,47,ohm,120
    COD124,Capacitor,100,uF,35
    COD125,Bobina,220,mH,15
    COD126,Transistor,10,V,75
    """
    File.write(path, String.trim(contenido))
  end

  # Leer archivo CSV y devolver {:ok, [Pieza...]} o {:error, mensaje}
  def leer_archivo(path) do
    case File.read(path) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        {:ok, parsear_lineas(lineas)}

      {:error, razon} ->
        {:error, "No se pudo leer el archivo: #{razon}"}
    end
  end

  # Recursivo: convertir líneas en structs Pieza
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

  # Recursivo: contar piezas con stock < t
  def contar_bajo_stock([], _t), do: 0
  def contar_bajo_stock([%Pieza{stock: s} | resto], t) when s < t do
    1 + contar_bajo_stock(resto, t)
  end
  def contar_bajo_stock([_ | resto], t), do: contar_bajo_stock(resto, t)
end
