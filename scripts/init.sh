NEED_INSTANTIATED=$1


export CHANNEL_NAME=mychannel
peer channel fetch oldest ${CHANNEL_NAME}.block -c ${CHANNEL_NAME}   -o orderer0.orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/msp/tlscacerts/tlsca.orderer.example.com-cert.pem
if [ ! -f ./${CHANNEL_NAME}.block ] ; then
	peer channel create -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}_channel.tx  -o orderer0.orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/msp/tlscacerts/tlsca.orderer.example.com-cert.pem
fi
peer channel join -b ${CHANNEL_NAME}.block 
peer channel update  -c $CHANNEL_NAME -f ./channel-artifacts/${CHANNEL_NAME}_${CORE_PEER_LOCALMSPID}anchors.tx -o orderer0.orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/msp/tlscacerts/tlsca.orderer.example.com-cert.pem

peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/sacc/
peer chaincode list --installed


if [ $NEED_INSTANTIATED -eq 1 ];then
	peer chaincode instantiate  -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["a","10"]}'  -P  "OR ('Org1MSP.peer','Org2MSP.peer','Org3MSP.peer')" -o orderer0.orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/msp/tlscacerts/tlsca.orderer.example.com-cert.pem
fi

#chaincode instantiate need some time
sleep 10

peer chaincode list --instantiated  -C $CHANNEL_NAME 

peer chaincode invoke  -C $CHANNEL_NAME -n mycc  -c '{"Args":["set","hello","wellcome to fabric"]}' -o orderer0.orderer.example.com:7050  --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/orderer.example.com/orderers/orderer0.orderer.example.com/msp/tlscacerts/tlsca.orderer.example.com-cert.pem
sleep 2
peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","hello"]}'