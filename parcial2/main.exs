defmodule Main do
  @moduledoc """
  Módulo principal que ejecuta todos los ejercicios en secuencia
  """
  
  def run do
    IO.puts("=== EJERCICIO 1 ===")
    {:ok, piezas} = Ejercicio1.leer_piezas("piezas.csv")
    IO.inspect(piezas)
    IO.puts("Piezas con stock < 50: #{Ejercicio1.contar_bajo_stock(piezas, 50)}")

    IO.puts("\n=== EJERCICIO 2 ===")
    {:ok, movs} = Ejercicio2.leer_movimientos("movimientos.csv")
    inventario = Ejercicio2.aplicar_movimientos(piezas, movs)
    IO.inspect(inventario)
    Ejercicio2.guardar_inventario("inventario_actual.csv", inventario)

    IO.puts("\n=== EJERCICIO 3 ===")
    total = Ejercicio3.total_en_rango(movs, "2025-09-09", "2025-09-12")
    IO.puts("Total movido en rango: #{total}")

    IO.puts("\n=== EJERCICIO 4 ===")
    unicos = Ejercicio4.eliminar(piezas)
    IO.inspect(unicos)

    IO.puts("\n=== EJERCICIO 5 ===")
    IO.puts("f(4) = #{Ejercicio5.f(4)}")
  end
end

Main.run()
