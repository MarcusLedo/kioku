import React from "react";
import styled from "styled-components";
import { NavBar } from "./NavBar";
import image from "./image.svg";
import vector2 from "./vector-2.svg";
import vector3 from "./vector-3.svg";
import vector4 from "./vector-4.svg";
import vector5 from "./vector-5.svg";
import vector from "./vector.svg";

const StyledAccountNotLogged = styled.div`
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

  .nav-bar-instance {
    bottom: 0 !important;
    left: 0 !important;
    position: absolute !important;
    top: unset !important;
  }

  .background {
    aspect-ratio: 0.94;
    background: radial-gradient(
      50% 50% at 65% 34%,
      rgba(255, 229, 236, 1) 8%,
      rgba(170, 151, 193, 1) 24%,
      rgba(110, 97, 164, 1) 48%,
      rgba(61, 52, 139, 1) 62%
    );
    border-radius: 519.5px / 554px;
    height: 1108px;
    left: -577px;
    position: absolute;
    top: -675px;
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
    width: 24.42%;
  }

  .group {
    background-color: #f8f9fa;
    border-radius: 32px;
    height: 300px;
    left: 65px;
    position: absolute;
    top: 316px;
    width: 300px;
  }

  .status-bar-2 {
    height: 2.25%;
    left: 10.47%;
    position: absolute;
    top: 2.90%;
    width: 81.86%;
  }

  .frame {
    align-items: center;
    background-color: #3d348b;
    border-radius: 8px;
    display: inline-flex;
    gap: 10px;
    justify-content: center;
    left: 178px;
    padding: 10px 12px;
    position: absolute;
    top: 390px;
  }

  .text-wrapper-2 {
    color: #ffffff;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 15px;
    font-weight: 400;
    letter-spacing: 0;
    line-height: normal;
    margin-top: -1.00px;
    position: relative;
    width: fit-content;
  }

  .div-wrapper {
    align-items: center;
    border: 1px solid;
    border-color: #3d348b;
    border-radius: 8px;
    display: inline-flex;
    gap: 10px;
    justify-content: center;
    left: 178px;
    padding: 10px 12px;
    position: absolute;
    top: 466px;
  }

  .text-wrapper-3 {
    color: #3d348b;
    font-family: "Poppins-Regular", Helvetica;
    font-size: 15px;
    font-weight: 400;
    letter-spacing: 0;
    line-height: normal;
    margin-top: -1.00px;
    position: relative;
    width: fit-content;
  }
`;

export const AccountNotLogged = () => {
  return (
    <StyledAccountNotLogged>
      <div className="status-bar">
        <div className="text-wrapper">9:41</div>

        <img className="vector" alt="Vector" src={vector} />

        <img className="vector-2" alt="Vector" src={image} />

        <img className="vector-3" alt="Vector" src={vector2} />
      </div>

      <NavBar
        className="nav-bar-instance"
        img="default-4.svg"
        property1="you"
        vectorDefault="default-3.svg"
        vectorDefault1="default-5.svg"
      />
      <div className="background" />

      <div className="div">Account</div>

      <div className="group" />

      <div className="status-bar-2">
        <div className="text-wrapper">9:41</div>

        <img className="vector" alt="Vector" src={vector3} />

        <img className="vector-2" alt="Vector" src={vector4} />

        <img className="vector-3" alt="Vector" src={vector5} />
      </div>

      <div className="frame">
        <div className="text-wrapper-2">Sign In</div>
      </div>

      <div className="div-wrapper">
        <div className="text-wrapper-3">Sign Up</div>
      </div>
    </StyledAccountNotLogged>
  );
};
