# Unicoding

Unicoding (_u8_) is a Linux tool to check byte-by-byte whether a file is in UTF-8 or US-ASCII byte-encoding.

Usage is simple, on the prompt type:

```u8 <filename>```

It will reply with **EMPTY** (if the file is empty), **US-ASCII** (if the file consists only of bytes in the 0-127 range), **UTF-8** (the most common Unicode encoding), or either **UTF-16LE** or **UTF-16BE** (for low-endian or big-endian UTF-16 - only if the file has a BOM), and otherwise **UNKNOWN**.
