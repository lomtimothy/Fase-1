import tkinter as tk
from tkinter import filedialog, messagebox, scrolledtext

# Mapeo para instrucciones de tipo R: determina el field 'function'
r_function_map = {
    "ADD": "100000",
    "SUB": "100010",
    "SLT": "101010",
    "OR" : "100101",
    "AND": "100100",
    "NOP": "000000"  # NOP se usará de forma especial (32 bits en 0)
}

# Mapeo para instrucciones de tipo I: determina el opcode
i_opcode_map = {
    "SW": "101011",
    "LW": "100011"
}

# Para instrucciones de tipo J el opcode es fijo
j_opcode = "000010"

def reg_to_bin(reg):
    """
    Convierte un registro del tipo '$4' a una cadena binaria de 5 bits.
    """
    try:
        num = int(reg.replace("$", ""))
        return format(num, '05b')
    except:
        return None

def imm_to_bin(imm, bits):
    """
    Convierte un inmediato (ej. "#101") a una cadena binaria de 'bits' bits.
    Si el número es negativo se utiliza complemento a dos.
    """
    try:
        if imm.startswith("#"):
            imm = imm[1:]
        num = int(imm)
        if num < 0:
            num = (1 << bits) + num
        return format(num, f'0{bits}b')
    except:
        return None

def convert_line(line):
    """
    Convierte una línea de código ASM a su representación en binario.
    Se determinan tres casos:
      - Tipo R: AND, OR, ADD, SUB, SLT y NOP (si es NOP se ignoran operandos y se retorna 32 ceros)
      - Tipo I: SW, LW
      - Tipo J: J
    """
    tokens = line.strip().split()
    if not tokens:
        return ""
    mnemonic = tokens[0].upper()

    # Instrucciones de tipo R
    if mnemonic in r_function_map:
        # NOP: se ignoran operandos; se retorna 32 bits de cero.
        if mnemonic == "NOP":
            return "0" * 32
        if len(tokens) != 4:
            return f"Error: Número incorrecto de operandos en '{line.strip()}'"
        # Se asume que el formato es: INSTRUCCIÓN destino, fuente, fuente
        rd = reg_to_bin(tokens[1])
        rs = reg_to_bin(tokens[2])
        rt = reg_to_bin(tokens[3])
        if None in (rd, rs, rt):
            return f"Error: Formato de registro incorrecto en '{line.strip()}'"
        opcode = "000000"  # Fijo para tipo R
        func = r_function_map[mnemonic]
        # Usamos el formato estándar MIPS: opcode + rs + rt + rd + shamt (00000) + funct
        binary_instruction = opcode + rs + rt + rd + "00000" + func
        return binary_instruction

    # Instrucciones de tipo I
    elif mnemonic in i_opcode_map:
        if len(tokens) != 4:
            return f"Error: Número incorrecto de operandos en '{line.strip()}'"
        # Se espera el orden: mnemonic, rt, rs, inmediato
        rt = reg_to_bin(tokens[1])
        rs = reg_to_bin(tokens[2])
        imm = imm_to_bin(tokens[3], 16)
        if None in (rt, rs, imm):
            return f"Error: Formato de registro o inmediato incorrecto en '{line.strip()}'"
        opcode = i_opcode_map[mnemonic]
        # Formato I: opcode (6) + rs (5) + rt (5) + inmediato (16)
        binary_instruction = opcode + rs + rt + imm
        return binary_instruction

    # Instrucciones de tipo J
    elif mnemonic == "J":
        if len(tokens) != 2:
            return f"Error: Número incorrecto de operandos en '{line.strip()}'"
        target = imm_to_bin(tokens[1], 26)
        if target is None:
            return f"Error: Formato de inmediato incorrecto en '{line.strip()}'"
        binary_instruction = j_opcode + target
        return binary_instruction

    else:
        return f"Error: Instrucción desconocida '{mnemonic}'"

def load_asm():
    filepath = filedialog.askopenfilename(
        title="Selecciona el archivo ASM",
        filetypes=[("ASM Files", "*.ASM"), ("All Files", "*.*")]
    )
    if filepath:
        try:
            with open(filepath, "r") as f:
                content = f.read()
            asm_text.delete(1.0, tk.END)
            asm_text.insert(tk.END, content)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el archivo: {e}")

def convert_asm_to_bin():
    asm_content = asm_text.get(1.0, tk.END)
    lines = asm_content.strip().splitlines()
    bin_lines = []
    errors = []

    for line in lines:
        # Se omiten líneas vacías o comentarios (líneas que inician con ; o //)
        if line.strip() == "" or line.strip().startswith(("//", ";")):
            continue
        converted = convert_line(line)
        if converted.startswith("Error:"):
            errors.append(converted)
        else:
            bin_lines.append(converted)

    if errors:
        messagebox.showerror("Errores en la conversión", "\n".join(errors))

    # Se unen todas las instrucciones binarias
    valid_bits = "".join(bin_lines)
    # Se asegura que el total de bits sea múltiplo de 8 (rellenando con 0 si es necesario)
    if len(valid_bits) % 8 != 0:
        valid_bits = valid_bits.ljust(((len(valid_bits) // 8) + 1) * 8, '0')
    # Se crea la "matriz" de 8 bits por línea
    rows = [valid_bits[i:i+8] for i in range(0, len(valid_bits), 8)]
    total_rows = 1000
    if len(rows) < total_rows:
        rows.extend(["00000000"] * (total_rows - len(rows)))
    else:
        rows = rows[:total_rows]

    matrix_result = "\n".join(rows)
    bin_text.delete(1.0, tk.END)
    bin_text.insert(tk.END, matrix_result)
    messagebox.showinfo("Conversión", "Conversión a binario completada.")

def save_bin():
    bin_result = bin_text.get(1.0, tk.END)
    if not bin_result.strip():
        messagebox.showwarning("Aviso", "No hay contenido binario para guardar.")
        return
    filepath = filedialog.asksaveasfilename(
        title="Guardar archivo binario",
        defaultextension=".txt",
        filetypes=[("Text Files", "*.txt")]
    )
    if filepath:
        try:
            with open(filepath, "w") as f:
                f.write(bin_result)
            messagebox.showinfo("Guardado", "Archivo guardado exitosamente.")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar el archivo: {e}")

# Creación de la ventana principal de la GUI
root = tk.Tk()
root.title("Conversor ASM a Binario")

# Botones de la interfaz
frame_buttons = tk.Frame(root)
frame_buttons.pack(pady=5)

btn_load = tk.Button(frame_buttons, text="Cargar ASM", command=load_asm)
btn_load.grid(row=0, column=0, padx=5)

btn_convert = tk.Button(frame_buttons, text="Convertir a Binario", command=convert_asm_to_bin)
btn_convert.grid(row=0, column=1, padx=5)

btn_save = tk.Button(frame_buttons, text="Guardar Binario", command=save_bin)
btn_save.grid(row=0, column=2, padx=5)

# Área de texto para mostrar el código ASM cargado
lbl_asm = tk.Label(root, text="Contenido ASM:")
lbl_asm.pack()
asm_text = scrolledtext.ScrolledText(root, width=70, height=10)
asm_text.pack(padx=10, pady=5)

# Área de texto para mostrar el resultado binario (matriz)
lbl_bin = tk.Label(root, text="Contenido Binario (Matriz 8x1000):")
lbl_bin.pack()
bin_text = scrolledtext.ScrolledText(root, width=70, height=20)
bin_text.pack(padx=10, pady=5)

root.mainloop()
