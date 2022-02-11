import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";

let NavBar = () => {
  let [account, setAccount] = useState(null);

  useEffect(() => {
    loadNavBar();
  }, []);

  let loadNavBar = async () => {
    await window.ethereum.enable();
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    setAccount(accounts[0]);
  };

  return (
    <div>
      <nav className="navbar navbar-dark fixed-top bg-dark">
        <div className="navbar-brand col-sm-3 col-md-3 mr-0">
          <h1 style={{ color: "white" }}>NFT MarketPlace</h1>
        </div>
        <ul className="navbar-nav px-3">
          <li className="nav-item text-nowrap d-none d-sm-none d-sm-block">
            {account}
          </li>
          <li>
            <Link to="/MyNFTs"> My NFTs</Link>
            <Link to="/Home"> Home</Link>
          </li>
        </ul>
      </nav>
    </div>
  );
};

export default NavBar;
