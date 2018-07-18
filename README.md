# kapu-resync
Kapu Resync Forked Node
*** an advanced script to automatically rebuild the kapu node, from the 5 highest peers ***
# first install jq
sudo apt-get install jq
# download resync in kapu-node/:
cd 
cd kapu-node
wget https://github.com/kapucoin/kapu-resync/blob/master/resync.sh
# to launch it when the node is in stuck (forkato) do:
cd kapu-node
bash resync.sh


SPECIAL Thanks @Corsaro
