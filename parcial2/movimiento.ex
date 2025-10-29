defmodule Movimiento do
  defstruct [:codigo, :tipo, :cantidad, :fecha]

  # Crear archivo CSV con movimientos de ejemplo
  def crear_archivo_ejemplo(path) do
    contenido = """
    COD123,ENTRADA,50,2025-09-10
    COD124,SALIDA,10,2025-09-12
    COD125,ENTRADA,20,2025-09-11
    COD126,SALIDA,5,2025-09-09
    """
    File.write(path, String.trim(contenido))
  end

  # Leer archivo de movimientos
  def leer_archivo(path) do
    case File.read(path) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        {:ok, parsear_lineas(lineas)}

      {:error, razon} ->
        {:error, "Error al leer movimientos: #{razon}"}
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

  # Aplicar movimientos al stock
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

  # Guardar inventario actualizado en CSV
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
