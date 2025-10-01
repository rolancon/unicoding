import os

var us_ascii = true
var utf_8 = true
var tail_bytes = 0

proc readFileByteByByte(filename: string) =
  try:
    # Open the file in binary mode
    let file = open(filename, fmRead)
    defer: file.close() # Ensure file is closed after use
    
    # Read file byte by byte
    var byte: uint8
    while not file.endOfFile:
      let bytesRead = file.readBuffer(addr(byte), 1)
      if bytesRead == 1:
        #echo "Byte: ", byte, " (char: ", cast[char](byte), ")"
        if byte > 127:
            us_ascii = false
            if tail_bytes == 0:
                # 110xxxxx
                if byte >= 192 and byte <= 223: tail_bytes = 1
                # 1110xxxx
                elif byte >= 224 and byte <= 239: tail_bytes = 2
                # 11110xxx
                elif byte >= 240 and byte <= 247: tail_bytes = 3
                else: utf_8 = false
            else:
                # 10xxxxxx
                if byte >= 128 and byte <= 191: tail_bytes = tail_bytes - 1
                else: utf_8 = false
      else:
        echo "Error: Failed to read byte"
        break
  except IOError:
    echo "Error: Could not open or read file '", filename, "': ", getCurrentExceptionMsg()

when isMainModule:
  if paramCount() < 1:
    echo "Usage: ", paramStr(0), " <filename>"
    quit(1)
  
  let filename = paramStr(1)
  if not fileExists(filename):
    echo "Error: File '", filename, "' does not exist"
    quit(1)
  
  readFileByteByByte(filename)

  if us_ascii: echo "US-ASCII"
  elif utf_8: echo "UTF-8"
  else: echo "UNKNOWN"
