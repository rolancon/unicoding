# Unicoding

Unicoding (_u8_) is a Linux tool to check byte-by-byte whether a file is in UTF-8 or US-ASCII byte-encoding.

Usage is simple, on the prompt type:

```u8 <filename>```

It will reply with either **UTF-8** (common Unicode encoding) or **US-ASCII** (if the file consists only of bytes in the 0-127 range), and otherwise **UNKNOWN**.
