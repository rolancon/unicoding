import os

var empty = false

var us_ascii = true
var utf_8 = true
var utf8_tail_bytes = 0

var utf_16le = false
var utf_16be = false
var bom_byte: uint8

proc readFileByteByByte(filename: string) =
  try:
    # Open the file in binary mode
    let file = open(filename, fmRead)
    defer: file.close() # Ensure file is closed after use
    let fileSize = file.getFileSize
    if fileSize == 0:
      empty = true
      return
    
    # Read file byte by byte
    var byte: uint8
    while not file.endOfFile:
      let bytesRead = file.readBuffer(addr(byte), 1)
      if bytesRead == 1:
        #echo "byte: ", byte, " (char: ", cast[char](byte), ")"
        if byte > 127:
            us_ascii = false
            if file.getFilePos == 1 and byte >= 254:
                #echo "BOM byte 1: ", byte, " (char: ", cast[char](byte), ")"
                utf_8 = false
                bom_byte = byte
            elif file.getFilePos == 2 and byte >= 254:
                #echo "BOM byte 2: ", byte, " (char: ", cast[char](byte), ")"
                utf_8 = false
                if byte != bom_byte:
                    if (fileSize > 2) and (fileSize mod 2 == 0): 
                      if byte < bom_byte: utf_16le = true
                      else: utf_16be = true
                      break
            elif utf_8_tail_bytes == 0:
                # 110xxxxx
                if byte >= 192 and byte <= 223: utf_8_tail_bytes = 1
                # 1110xxxx
                elif byte >= 224 and byte <= 239: utf_8_tail_bytes = 2
                # 11110xxx
                elif byte >= 240 and byte <= 247: utf_8_tail_bytes = 3
                else: utf_8 = false
            else:
                # 10xxxxxx
                if byte >= 128 and byte <= 191: utf_8_tail_bytes = utf_8_tail_bytes - 1
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

  if empty: echo "EMPTY"
  elif us_ascii: echo "US-ASCII"
  elif utf_8: echo "UTF-8"
  elif utf_16le: echo "UTF-16LE"
  elif utf_16be: echo "UTF-16BE"
  else: echo "UNKNOWN"
