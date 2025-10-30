defmodule Main do
  def run do
    #Crear archivos CSV automáticamente
    IO.puts("Creando archivos CSV de ejemplo...")
    Pieza.crear_archivo_ejemplo("piezas.csv")
    Movimiento.crear_archivo_ejemplo("movimientos.csv")

    #Leer archivos
    {:ok, piezas} = Pieza.leer_archivo("piezas.csv")
    {:ok, movs} = Movimiento.leer_archivo("movimientos.csv")

    #Mostrar datos
    IO.puts("\n PIEZAS ")
    IO.inspect(piezas)
    IO.puts("Piezas con stock < 50: #{Pieza.contar_bajo_stock(piezas, 50)}")

    IO.puts("\n MOVIMIENTOS ")
    IO.inspect(movs)

    #Aplicar movimientos
    inventario = Movimiento.aplicar_movimientos(piezas, movs)
    IO.puts("\nInventario actualizado:")
    IO.inspect(inventario)

    #Guardar resultado
    Movimiento.guardar_inventario("inventario_actual.csv", inventario)
    IO.puts("Archivo inventario_actual.csv creado")

    #Calcular total en rango
    total = Inventario.total_en_rango(movs, "2025-09-09", "2025-09-12")
    IO.puts("\nTotal movido entre 2025-09-09 y 2025-09-12: #{total}")

    #Eliminar duplicados
    unicos = Inventario.eliminar_duplicados(piezas)
    IO.puts("\nLista sin duplicados:")
    IO.inspect(unicos)

    #Ejercicio ComplejoB
    n = 7
    resultado = ComplejoB.f(n)
    IO.puts("\nResultado de f(#{n}) = #{resultado}")
  end
end

Main.run()
