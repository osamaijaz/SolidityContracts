import React, { useEffect, useState } from "react";
import Cryptobird from "../abis/Cryptobird.json";
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from "mdb-react-ui-kit";
import Web3 from "web3";

var INIContract = require("web3-eth-contract");
function MyNFT() {
  let [Contract, setContract] = useState(null);
  let [TotalSupply, settotalSupply] = useState(null);
  let [account, setAccount] = useState(null);
  let [cryptobird, setcryptobird] = useState([]);
  let [totalNFTS, setTotalNFTS] = useState(null);
  let [myNFTs, setMyNFTs] = useState([]);

  useEffect(() => {
    loadWeb3();
  }, []);

  async function loadWeb3() {
    const web3 = new Web3("http://localhost:7545");
    await window.ethereum.enable();
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    setAccount(accounts[0]);
    let networkid = await web3.eth.net.getId();
    const networkData = await Cryptobird.networks[networkid];
    if (networkData) {
      const abi = Cryptobird.abi;
      const address = networkData.address;
      INIContract.setProvider("http://localhost:7545");
      const contract = new INIContract(abi, address);
      setContract(contract);
      console.log(contract);
      const totalSupply = await contract.methods.totalSupply().call();
      settotalSupply(totalSupply);
      for (let i = 0; i <= totalSupply; i++) {
        const CryptoBird = await contract.methods.CryptoBird(i).call();
        setcryptobird((cryptobird) => [...cryptobird, CryptoBird]);
      }
    } else {
      alert("Contract not deployed");
    }
  }

  let mint = (CryptoBird) => {
    Contract.methods
      .mint(CryptoBird)
      .send({ from: account, gas: 2000000 })
      .once("receipt", (receipt) => {
        console.log(receipt);
      });
  };

  // let transfer = () => {
  //   let account2 = "0x0Ad16E8937AC34D2C2E8283B1f1046DbBfee6265";
  //   Contract.methods
  //     .transferFrom(account, account2, "2")
  //     .send({ from: account, gas: 2000000 });
  // };

  let ownedNFTs = async () => {
    for (let i = 0; i <= TotalSupply; i++) {
      const index = await Contract.methods.tokenOfOwnerByIndex(account, i).call();
      const nft =  await Contract.methods.CryptoBird(index).call();
      setMyNFTs((myNFTs) => [...myNFTs, nft]);
      console.log(nft);
    }
  };

  return (
    <div className="container-fluid mt-1">
      <div className="row">
        <main role="main" className="col-lg-12 d-flex text-center">
          <div className="content mr-auto ml-auto" style={{ opacity: "0.8" }}>
            <h1 style={{ color: "white", marginTop: "5%" }}>NFT Marketplace</h1>
            <form
              onSubmit={(event) => {
                event.preventDefault();
                const CryptoBird = cryptobird.value;
                mint(CryptoBird);
              }}
            >
              <input
                style={{ marginTop: "40px" }}
                type="text"
                placeholder="Add a file location"
                className="form-control mb-1"
                ref={(input) => {
                  cryptobird = input;
                }}
              />
              <input
                style={{ margin: "6px" }}
                type="submit"
                className="btn btn-primary btn-black"
                value="MINT"
              />
            </form>
            <button onClick={ownedNFTs}>Show My NFTS</button>
            {myNFTs.map((NFT, key) => {
              return (
                <div key={key}>
                  <div>
                    <MDBCard className="token img" style={{ width: "210px" }}>
                      <MDBCardImage
                        src={NFT}
                        position="top"
                        height="200rem"
                        style={{ marginRight: "4px" }}
                      />
                      <MDBCardBody>
                        <MDBCardTitle> CryptoBirds</MDBCardTitle>
                        <MDBCardText>Generated NFTS</MDBCardText>
                        <MDBBtn href={NFT}> Download</MDBBtn>
                      </MDBCardBody>
                    </MDBCard>
                  </div>
                </div>
              );
            })}
          </div>
        </main>
      </div>
    </div>
  );
}

export default MyNFT;
