import React from "react";
import styled from "styled-components";
import { Navbar } from "./Navbar";
import image from "./image.svg";
import polygon12 from "./polygon-1-2.svg";
import polygon13 from "./polygon-1-3.svg";
import polygon14 from "./polygon-1-4.svg";
import polygon15 from "./polygon-1-5.svg";
import polygon16 from "./polygon-1-6.svg";
import polygon17 from "./polygon-1-7.svg";
import polygon1 from "./polygon-1.svg";
import vector2 from "./vector-2.svg";
import vector3 from "./vector-3.svg";
import vector4 from "./vector-4.svg";
import vector5 from "./vector-5.svg";
import vector6 from "./vector-6.svg";
import vector from "./vector.svg";

const StyledDeckListing = styled.div`
  background-color: #ced4da;
  height: 932px;
  min-width: 430px;
  overflow: hidden;
  position: relative;
  width: 100%;

  .status-bar {
    height: 2.25%;
    left: 10.47%;
    position: absolute;
    top: 2.47%;
    width: 81.86%;
  }

  .text-wrapper {
    color: #ffffff;
    font-family: "Poppins-Bold", Helvetica;
    font-size: 14px;
    font-weight: 700;
    height: 100%;
    left: 0;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 0;
    width: 7.95%;
  }

  .vector {
    height: 43.86%;
    left: 94.20%;
    position: absolute;
    top: 24.56%;
    width: 5.23%;
  }

  .vector-2 {
    height: 61.40%;
    left: 86.66%;
    position: absolute;
    top: 7.02%;
    width: 5.23%;
  }

  .vector-3 {
    height: 70.18%;
    left: 79.55%;
    position: absolute;
    top: 0;
    width: 4.84%;
  }

  .background {
    aspect-ratio: 0.94;
    background: radial-gradient(
      50% 50% at 65% 34%,
      rgba(255, 229, 236, 1) 8%,
      rgba(170, 151, 193, 1) 24%,
      rgba(110, 97, 164, 1) 48%,
      rgba(61, 52, 139, 1) 83%
    );
    border-radius: 519.5px / 554px;
    height: 1108px;
    left: -533px;
    position: absolute;
    top: -636px;
    transform: rotate(81.24deg);
    width: 1039px;
  }

  .div {
    color: #ffffff;
    font-family: "Poppins-Bold", Helvetica;
    font-size: 24px;
    font-weight: 700;
    height: 3.86%;
    left: 9.53%;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 6.87%;
    width: 17.44%;
  }

  .status-bar-2 {
    height: 2.25%;
    left: 10.47%;
    position: absolute;
    top: 2.90%;
    width: 81.86%;
  }

  .navbar-variant {
    background-color: #ffffff !important;
    left: 0 !important;
    position: absolute !important;
  }

  .group {
    background-color: #f8f9fa;
    border-radius: 32px;
    box-shadow: 0px 4px 4px #00000040;
    display: flex;
    height: 655px;
    left: 14px;
    position: absolute;
    top: 192px;
    width: 402px;
  }

  .frame {
    align-items: flex-end;
    display: flex;
    height: 625px;
    margin-left: 16px;
    margin-top: 30px;
    overflow: hidden;
    overflow-y: scroll;
    width: 361px;
  }

  .frame::-webkit-scrollbar {
    display: none;
    width: 0;
  }

  .group-2 {
    height: 784px;
    margin-bottom: -159.39px;
    position: relative;
    width: 361px;
  }

  .group-3 {
    height: 184px;
    left: 0;
    position: absolute;
    top: 0;
    width: 164px;
  }

  .rectangle-2 {
    aspect-ratio: 0.85;
    background: linear-gradient(
      143deg,
      rgba(172, 175, 238, 1) 3%,
      rgba(169, 171, 238, 1) 56%,
      rgba(118, 120, 237, 1) 76%,
      rgba(61, 52, 139, 1) 100%
    );
    border: 1px solid;
    border-color: #7678ed;
    border-radius: 22px;
    box-shadow: 0px 4px 4px #00000040;
    height: 184px;
    left: 1px;
    position: absolute;
    top: 0;
    width: 158px;
  }

  .polygon {
    aspect-ratio: 1;
    height: 25px;
    left: 114px;
    position: absolute;
    top: 150px;
    width: 25px;
  }

  .text-wrapper-2 {
    color: #31296e;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 20px;
    font-weight: 400;
    left: 11px;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 15px;
    width: 136px;
  }

  .text-wrapper-3 {
    color: #3d348b;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 15px;
    font-weight: 400;
    left: 43px;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 79px;
  }

  .text-wrapper-4 {
    color: #282257;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 15px;
    font-weight: 400;
    left: 97px;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 149px;
  }

  .group-4 {
    height: 184px;
    left: 203px;
    position: absolute;
    top: 0;
    width: 164px;
  }

  .group-5 {
    height: 184px;
    left: 5px;
    position: absolute;
    top: 600px;
    width: 164px;
  }

  .group-6 {
    height: 184px;
    left: 5px;
    position: absolute;
    top: 198px;
    width: 164px;
  }

  .group-7 {
    height: 184px;
    left: 203px;
    position: absolute;
    top: 198px;
    width: 164px;
  }

  .text-wrapper-5 {
    color: #282257;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 15px;
    font-weight: 400;
    left: 91px;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 148px;
  }

  .group-8 {
    height: 184px;
    left: 5px;
    position: absolute;
    top: 400px;
    width: 164px;
  }

  .group-9 {
    height: 184px;
    left: 203px;
    position: absolute;
    top: 400px;
    width: 164px;
  }

  .group-10 {
    height: 50px;
    left: 47px;
    position: absolute;
    top: 121px;
    width: 337px;
  }

  .text-wrapper-6 {
    color: #dee2e6;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 12px;
    font-weight: 400;
    left: 46px;
    letter-spacing: 0;
    line-height: normal;
    position: absolute;
    top: 16px;
  }

  .rectangle-3 {
    aspect-ratio: 6.7;
    border: 1px solid;
    border-color: #dee2e6;
    border-radius: 22px;
    height: 50px;
    left: 0;
    position: absolute;
    top: calc(50.00% - 25px);
    width: 99.41%;
  }

  .vector-4 {
    aspect-ratio: 1;
    height: 18px;
    left: 5.34%;
    position: absolute;
    top: calc(50.00% - 9px);
    width: 5.34%;
  }
`;

export const DeckListing = () => {
  return (
    <StyledDeckListing>
      <div className="status-bar">
        <div className="text-wrapper">9:41</div>

        <img className="vector" alt="Vector" src={vector} />

        <img className="vector-2" alt="Vector" src={image} />

        <img className="vector-3" alt="Vector" src={vector2} />
      </div>

      <div className="background" />

      <div className="div">Decks</div>

      <div className="status-bar-2">
        <div className="text-wrapper">9:41</div>

        <img className="vector" alt="Vector" src={vector3} />

        <img className="vector-2" alt="Vector" src={vector4} />

        <img className="vector-3" alt="Vector" src={vector5} />
      </div>

      <Navbar
        className="navbar-variant"
        img="default-5.svg"
        vectorDefault="default-4.svg"
        vectorDefault1="default-6.svg"
      />
      <div className="group">
        <div className="frame">
          <div className="group-2">
            <div className="group-3">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon1} />

              <div className="text-wrapper-2">Japanese</div>

              <div className="text-wrapper-3">126 cards</div>

              <div className="text-wrapper-4">36</div>
            </div>

            <div className="group-4">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon12} />

              <div className="text-wrapper-2">CCNA</div>

              <div className="text-wrapper-3">84 cards</div>

              <div className="text-wrapper-4">12</div>
            </div>

            <div className="group-5">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon13} />

              <div className="text-wrapper-2">Chemistry</div>

              <div className="text-wrapper-3">12 cards</div>

              <div className="text-wrapper-4">12</div>
            </div>

            <div className="group-6">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon14} />

              <div className="text-wrapper-2">AI</div>

              <div className="text-wrapper-3">21 cards</div>

              <div className="text-wrapper-4">0</div>
            </div>

            <div className="group-7">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon15} />

              <div className="text-wrapper-2">OOP</div>

              <div className="text-wrapper-3">100 cards</div>

              <div className="text-wrapper-5">54</div>
            </div>

            <div className="group-8">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon16} />

              <div className="text-wrapper-2">Logic</div>

              <div className="text-wrapper-3">126 cards</div>

              <div className="text-wrapper-4">36</div>
            </div>

            <div className="group-9">
              <div className="rectangle-2" />

              <img className="polygon" alt="Polygon" src={polygon17} />

              <div className="text-wrapper-2">Biology</div>

              <div className="text-wrapper-3">no cards</div>

              <div className="text-wrapper-4">0</div>
            </div>
          </div>
        </div>
      </div>

      <div className="group-10">
        <div className="text-wrapper-6">Search for deck...</div>

        <div className="rectangle-3" />

        <img className="vector-4" alt="Vector" src={vector6} />
      </div>
    </StyledDeckListing>
  );
};
