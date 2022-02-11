import React, { useEffect, useState } from "react";
import Cryptobird from "../abis/Cryptobird.json";
import Web3 from "web3";
import "./App.css";

import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
} from "mdb-react-ui-kit";
var INIContract = require("web3-eth-contract");

export default function App() {
  let [cryptobird, setcryptobird] = useState([]);
  useEffect(() => {
    loadWeb3();
  }, []);

  async function loadWeb3() {
    const web3 = new Web3("http://localhost:7545");
    // await window.ethereum.enable();
    // const accounts = await window.ethereum.request({
    //   method: "eth_requestAccounts",
    // });
    // setAccount(accounts[0]);
    let networkid = await web3.eth.net.getId();
    const networkData = await Cryptobird.networks[networkid];
    if (networkData) {
      const abi = Cryptobird.abi;
      const address = networkData.address;
      INIContract.setProvider("http://localhost:7545");
      const contract = new INIContract(abi, address);
      const totalSupply = await contract.methods.totalSupply().call();

      for (let i = 0; i <= totalSupply; i++) {
        const CryptoBird = await contract.methods.CryptoBird(i).call();
        setcryptobird((cryptobird) => [...cryptobird, CryptoBird]);
      }
    } else {
      alert("Contract not deployed");
    }
  }

  return (
    <div className="container-filled">
      <div className="container-fluid mt-1">
        <div className="row textCenter">
          {cryptobird.map((CryptoBird, key) => {
            return (
              <div key={key}>
                <div>
                  <MDBCard className="token img" style={{ width: "210px" }}>
                    <MDBCardImage
                      src={CryptoBird}
                      position="top"
                      height="200rem"
                      style={{ marginRight: "4px" }}
                    />
                    <MDBCardBody>
                      <MDBCardTitle> CryptoBirds</MDBCardTitle>
                      <MDBCardText>Generated NFTS</MDBCardText>
                      <MDBBtn href={CryptoBird}> Download</MDBBtn>
                      {/* <MDBBtn onClick={transfer}> Transfer</MDBBtn> */}
                    </MDBCardBody>
                  </MDBCard>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
