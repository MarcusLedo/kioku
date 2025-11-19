import React from "react";
import styled from "styled-components";
import { NavBar } from "./NavBar";
import image from "./image.svg";
import line1 from "./line-1.svg";
import line2 from "./line-2.svg";
import line3 from "./line-3.svg";
import stacks from "./stacks.png";
import vector2 from "./vector-2.svg";
import vector3 from "./vector-3.svg";
import vector4 from "./vector-4.svg";
import vector5 from "./vector-5.svg";
import vector6 from "./vector-6.svg";
import vector7 from "./vector-7.svg";
import vector8 from "./vector-8.svg";
import vector9 from "./vector-9.svg";
import vector from "./vector.svg";

const AccountContainer = styled.div`
  background-color: #ced4da;
  height: 932px;
  min-width: 430px;
  overflow: hidden;
  position: relative;
  width: 100%;
`;

const StatusBar = styled.div`
  height: 2.25%;
  left: 10.47%;
  position: absolute;
  top: 2.47%;
  width: 81.86%;
`;

const TextWrapper = styled.div`
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
`;

const VectorImage = styled.img`
  position: absolute;
`;

const Background = styled.div`
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
  left: -577px;
  position: absolute;
  top: -675px;
  width: 1039px;
`;

const Title = styled.div`
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
`;

const Group = styled.div`
  background-color: #f8f9fa;
  border-radius: 32px;
  box-shadow: 0px 4px 4px #00000040;
  height: 518px;
  left: 29px;
  position: absolute;
  top: 275px;
  width: 372px;
`;

const AccountSettings = styled.div`
  height: 64px;
  left: 0;
  position: absolute;
  top: 222px;
  width: 374px;
`;

const Rectangle = styled.div`
  background-color: #f8f9fa;
  height: 64px;
  left: 0;
  position: absolute;
  top: 0;
  width: 372px;
`;

const TextWrapper2 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 15px;
  font-weight: 400;
  left: 81px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 23px;
`;

const MembershipSection = styled.div`
  height: 64px;
  left: 0;
  position: absolute;
  top: 158px;
  width: 374px;
`;

const YourDecksSection = styled.div`
  height: 64px;
  left: 0;
  position: absolute;
  top: 94px;
  width: 374px;
`;

const StacksImage = styled.img`
  aspect-ratio: 1;
  height: 24px;
  left: 40px;
  position: absolute;
  top: 23px;
  width: 24px;
`;

const ProfileSection = styled.div`
  background-color: #f8f9fa;
  display: flex;
  gap: 17px;
  height: 64px;
  left: 0;
  position: absolute;
  top: 30px;
  width: 372px;
`;

const Line = styled.img`
  height: 1px;
  left: 24px;
  object-fit: cover;
  position: absolute;
  width: 323px;
`;

const ProfilePicUser = styled.div`
  box-shadow: 0px 4px 4px #00000040;
  height: 103px;
  left: 29px;
  position: absolute;
  top: 151px;
  width: 374px;
`;

const Rectangle3 = styled.div`
  background-color: #f8f9fa;
  border-radius: 32px;
  height: 103px;
  left: 0;
  position: absolute;
  top: 0;
  width: 372px;
`;

const TextWrapper4 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 20px;
  font-weight: 400;
  left: 119px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 37px;
`;

const StatusBar2 = styled.div`
  height: 2.25%;
  left: 10.47%;
  position: absolute;
  top: 2.90%;
  width: 81.86%;
`;

export const Account = () => {
  return (
    <AccountContainer>
      <StatusBar>
        <TextWrapper>9:41</TextWrapper>
        <VectorImage className="vector" alt="Vector" src={vector} />
        <VectorImage className="vector-2" alt="Vector" src={image} />
        <VectorImage className="vector-3" alt="Vector" src={vector2} />
      </StatusBar>

      <NavBar
        className="nav-bar-instance"
        img="default-4.svg"
        property1="you"
        vectorDefault="default-3.svg"
        vectorDefault1="default-5.svg"
      />
      <Background />
      <Title>Account</Title>

      <Group>
        <AccountSettings>
          <Rectangle />
          <TextWrapper2>Account Settings</TextWrapper2>
          <VectorImage className="vector-4" alt="Vector" src={vector3} />
        </AccountSettings>

        <MembershipSection>
          <Rectangle />
          <TextWrapper2>Membership</TextWrapper2>
          <VectorImage className="vector-4" alt="Vector" src={vector4} />
        </MembershipSection>

        <YourDecksSection>
          <Rectangle />
          <TextWrapper2>Your Decks</TextWrapper2>
          <StacksImage className="stacks" alt="Stacks" src={stacks} />
        </YourDecksSection>

        <ProfileSection>
          <VectorImage className="vector-5" alt="Vector" src={vector5} />
          <TextWrapper className="text-wrapper-3">Your Profile</TextWrapper>
        </ProfileSection>

        <Line className="line" alt="Line" src={line2} />
        <Line className="line-2" alt="Line" src={line1} />
        <Line className="line-3" alt="Line" src={line3} />
      </Group>

      <ProfilePicUser>
        <Rectangle3 />
        <VectorImage className="vector-6" alt="Vector" src={vector6} />
        <TextWrapper4>Username</TextWrapper4>
      </ProfilePicUser>

      <StatusBar2>
        <TextWrapper>9:41</TextWrapper>
        <VectorImage className="vector" alt="Vector" src={vector7} />
        <VectorImage className="vector-2" alt="Vector" src={vector8} />
        <VectorImage className="vector-3" alt="Vector" src={vector9} />
      </StatusBar2>
    </AccountContainer>
  );
};
