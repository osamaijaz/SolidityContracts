import React, { useEffect, useState } from "react";
import MyNFTs from "./MyNFTs";
import MarketPlace from "./MarketPlace";
import { Routes, Route } from "react-router-dom";
import NavBar from "./NavBar";
export default function App() {
  return (
    <div className="app">
      <div className="navbar">
        <NavBar />
      </div>
      <div className="main">
        <div className="routes">
          <Routes>
            <Route path="/MyNFTs" element={<MyNFTs />} />
            <Route path="/Home" element={<MarketPlace/>} />
            <Route path="/" element={<MarketPlace />} />
          </Routes>
        </div>
      </div>
    </div>
  );
}
