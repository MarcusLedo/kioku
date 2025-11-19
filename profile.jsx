import React from "react";
import styled from "styled-components";
import { NavBar } from "./NavBar";
import ellipse2 from "./ellipse-2.png";
import line4 from "./line-4.svg";
import rectangle8 from "./rectangle-8.png";
import vector2 from "./vector-2.svg";
import vector3 from "./vector-3.svg";
import vector4 from "./vector-4.svg";
import vector5 from "./vector-5.svg";
import vector6 from "./vector-6.svg";
import vector7 from "./vector-7.svg";
import vector8 from "./vector-8.svg";
import vector from "./vector.svg";

const YourProfileContainer = styled.div`
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
  left: -305px;
  position: absolute;
  top: 672px;
  width: 1039px;
`;

const Div = styled.div`
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
  left: -305px;
  position: absolute;
  top: -836px;
  width: 1039px;
`;

const TextWrapper2 = styled.div`
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
  width: 33.02%;
`;

const ProfileSection = styled.div`
  box-shadow: 0px 4px 4px #00000040;
  height: 305px;
  left: 12px;
  position: absolute;
  top: 124px;
  width: 406px;
`;

const Rectangle2 = styled.div`
  background-color: #f8f9fa;
  border-radius: 0px 0px 32px 32px;
  height: 157px;
  left: 0;
  position: absolute;
  top: 148px;
  width: 406px;
`;

const ProfileBanner = styled.div`
  height: 207px;
  left: 0;
  position: absolute;
  top: 0;
  width: 406px;
`;

const Rectangle3 = styled.img`
  height: 148px;
  left: 0;
  object-fit: cover;
  position: absolute;
  top: 0;
  width: 406px;
`;

const Ellipse = styled.div`
  aspect-ratio: 1;
  background-color: #f8f9fa;
  border-radius: 66.5px;
  height: 133px;
  left: 136px;
  position: absolute;
  top: 74px;
  width: 133px;
`;

const Ellipse2 = styled.img`
  aspect-ratio: 1;
  height: 125px;
  left: 140px;
  object-fit: cover;
  position: absolute;
  top: 78px;
  width: 125px;
`;

const ProfileName = styled.div`
  height: 30px;
  left: 139px;
  position: absolute;
  top: 207px;
  width: 129px;
`;

const TextWrapper3 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Bold", Helvetica;
  font-size: 20px;
  font-weight: 700;
  left: 0;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 0;
`;

const Frame = styled.div`
  align-items: center;
  background-color: #3d348b;
  border-radius: 8px;
  display: inline-flex;
  gap: 10px;
  justify-content: center;
  left: 139px;
  padding: 10px 12px;
  position: absolute;
  top: 249px;
`;

const TextWrapper4 = styled.div`
  color: #ffffff;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 15px;
  font-weight: 400;
  letter-spacing: 0;
  line-height: normal;
  margin-top: -1.00px;
  position: relative;
  width: fit-content;
`;

const ProfileInfo = styled.div`
  box-shadow: 0px 4px 4px #00000040;
  height: 375px;
  left: 12px;
  position: absolute;
  top: 442px;
  width: 420px;
`;

const Rectangle4 = styled.div`
  background-color: #f8f9fa;
  border-radius: 32px;
  height: 375px;
  left: 0;
  position: absolute;
  top: 0;
  width: 406px;
`;

const Line = styled.img`
  height: 3px;
  left: 0;
  object-fit: cover;
  position: absolute;
  top: 63px;
  width: 406px;
`;

const TextWrapper5 = styled.div`
  color: #6c757d;
  font-family: "Poppins-Medium", Helvetica;
  font-size: 16px;
  font-weight: 500;
  left: 26px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 24px;
`;

const TextWrapper6 = styled.div`
  color: #6c757d;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 32px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 81px;
`;

const TextWrapper7 = styled.div`
  color: #6c757d;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 32px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 133px;
`;

const TextWrapper8 = styled.div`
  color: #6c757d;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 32px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 188px;
`;

const TextWrapper9 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 59px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 102px;
`;

const TextWrapper10 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 59px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 154px;
`;

const ElementLinkToShared = styled.p`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  left: 59px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 209px;
`;

const Span = styled.span`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 14px;
  font-weight: 400;
  letter-spacing: 0;
`;

const TextWrapper11 = styled.span`
  font-family: "Poppins-Italic", Helvetica;
  font-style: italic;
`;

export const YourProfile = () => {
  return (
    <YourProfileContainer>
      <StatusBar>
        <TextWrapper>9:41</TextWrapper>
        <VectorImage className="vector" alt="Vector" src={vector} />
        <VectorImage className="vector-2" alt="Vector" src={vector2} />
        <VectorImage className="vector-3" alt="Vector" src={vector3} />
      </StatusBar>

      <Background />

      <Div />

      <NavBar
        className="nav-bar-instance"
        img="default-3.svg"
        property1="you"
        vectorDefault="default-2.svg"
        vectorDefault1="default-4.svg"
      />
      <TextWrapper2>Your Profile</TextWrapper2>

      <StatusBar>
        <TextWrapper>9:41</TextWrapper>
        <VectorImage className="vector" alt="Vector" src={vector4} />
        <VectorImage className="vector-2" alt="Vector" src={vector5} />
        <VectorImage className="vector-3" alt="Vector" src={vector6} />
      </StatusBar>

      <ProfileSection>
        <Rectangle2 />
        <ProfileBanner>
          <Rectangle3
            className="rectangle-3"
            alt="Rectangle"
            src={rectangle8}
          />
          <Ellipse />
          <Ellipse2 className="ellipse-2" alt="Ellipse" src={ellipse2} />
        </ProfileBanner>

        <ProfileName>
          <TextWrapper3>AngryCat</TextWrapper3>
          <VectorImage className="vector-4" alt="Vector" src={vector7} />
        </ProfileName>

        <Frame>
          <TextWrapper4>Edit Profile</TextWrapper4>
          <VectorImage className="vector-5" alt="Vector" src={vector8} />
        </Frame>
      </ProfileSection>

      <ProfileInfo>
        <Rectangle4 />
        <Line className="line" alt="Line" src={line4} />
        <TextWrapper5>Personal Info</TextWrapper5>
        <TextWrapper6>Username</TextWrapper6>
        <TextWrapper7>User ID</TextWrapper7>
        <TextWrapper8>Shared Decks</TextWrapper8>
        <TextWrapper9>AngryCat</TextWrapper9>
        <TextWrapper10>@angrycat_2022</TextWrapper10>
        <ElementLinkToShared>
          <Span>4 &lt;</Span>
          <TextWrapper11>link to shared decks</TextWrapper11>
          <Span>&gt;</Span>
        </ElementLinkToShared>
      </ProfileInfo>
    </YourProfileContainer>
  );
};
