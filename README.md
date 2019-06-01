
# ---------- build ----------

# build libs & make demo
make all

# only make demo
make

# ---------- run ----------

# call
./app sip:id@ip:port
example:
    ./app sip:101@192.168.10.1:5060
