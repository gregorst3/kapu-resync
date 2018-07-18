# Kapu-resync
Kapu Resync Forked Node
*** an advanced script to automatically rebuild the kapu node, from the 5 highest peers ***
# First
```
sudo apt-get install jq -y
sudo apt-get install psmisc -y
```
# Download resync in kapu-node/:
```
cd ~
cd kapu-node
wget https://raw.githubusercontent.com/kapucoin/kapu-resync/master/resync.sh
```

# To launch it when the node is in stuck (forked) do:
```
cd kapu-node

bash resync.sh
```


SPECIAL Thanks @Corsaro
