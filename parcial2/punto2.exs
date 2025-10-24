defmodule Ejercicio2 do
  @moduledoc """
  Procesamiento de movimientos de inventario
  """

  alias Ejercicio1.Pieza

  defmodule Movimiento do
    defstruct [:codigo, :tipo, :cantidad, :fecha]
  end

  def leer_movimientos(archivo) do
    case File.read(archivo) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        {:ok, parsear_linas(lineas)}

      {:error, razon} ->
        {:error, "No se pudo leer el archivo: #{razon}"}
    end
  end

  defp parsear_lineas([]), do: []
  defp parsear_lineas([linea | resto]) do
    [cod, tipo, cant, fecha] = String.split(linea, ",")
    mov = %Movimiento{
      codigo: String.trim(cod),
      tipo: String.trim(tipo),
      cantidad: String.to_integer(String.trim(cant)),
      fecha: String.trim(fecha)
    }
    [mov | parsear_lineas(resto)]
  end

  # A. Aplicar los movimientos al stock de cada pieza
  def aplicar_movimientos([], _), do: []
  def aplicar_movimientos([pieza | resto], movimientos) do
    nuevo_stock = actualizar_stock(pieza, movimientos)
    nueva_pieza = %Pieza{pieza | stock: nuevo_stock}
    [nueva_pieza | aplicar_movimientos(resto, movimientos)]
  end

  defp actualizar_stock(%Pieza{codigo: cod, stock: s}, []), do: s
  defp actualizar_stock(%Pieza{codigo: cod, stock: s}, [%Movimiento{codigo: c, tipo: tipo, cantidad: cant} | resto]) do
    if cod == c do
      case tipo do
        "ENTRADA" -> actualizar_stock(%Pieza{codigo: cod, stock: s + cant}, resto)
        "SALIDA" -> actualizar_stock(%Pieza{codigo: cod, stock: s - cant}, resto)
      end
    else
      actualizar_stock(%Pieza{codigo: cod, stock: s}, resto)
    end
  end

  # B. Guardar inventario actualizado en archivo CSV
  def guardar_inventario(path, piezas) do
    contenido = generar_csv(piezas)
    File.write(path, contenido)
  end

  defp generar_csv([]), do: ""
  defp generar_csv([%Pieza{} = p | resto]) do
    linea = "#{p.codigo},#{p.nombre},#{p.valor},#{p.unidad},#{p.stock}\n"
    linea <> generar_csv(resto)
  end
end
