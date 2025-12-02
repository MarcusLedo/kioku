import React from "react";
import styled from "styled-components";
import { Circle } from "./Circle";
import { NavBar } from "./NavBar";
import background from "./background.png";
import image from "./image.svg";
import polygon12 from "./polygon-1-2.svg";
import polygon13 from "./polygon-1-3.svg";
import polygon14 from "./polygon-1-4.svg";
import polygon15 from "./polygon-1-5.svg";
import polygon1 from "./polygon-1.svg";
import vector2 from "./vector-2.svg";
import vector3 from "./vector-3.svg";
import vector4 from "./vector-4.svg";
import vector5 from "./vector-5.svg";
import vector from "./vector.png";
import vector1 from "./vector.svg";

const StyledHomepage = styled.div`
  background-color: #ced4da;
  height: 932px;
  min-width: 430px;
  position: relative;
  width: 100%;
`;

const RecentDecksSection = styled.div`
  display: flex;
  gap: 112px;
  height: 44px;
  left: 44px;
  position: absolute;
  top: 517px;
  width: 354px;
`;

const TextWrapper = styled.div`
  color: #3d348b;
  font-family: "Poppins-Bold", Helvetica;
  font-size: 24px;
  font-weight: 700;
  height: 36px;
  letter-spacing: 0;
  line-height: normal;
  margin-top: 2px;
  width: 166px;
`;

const Frame = styled.div`
  align-items: center;
  display: inline-flex;
  gap: 10px;
  height: 44px;
  justify-content: center;
  padding: 10px;
  position: relative;
  width: 74px;
`;

const Div = styled.div`
  color: #7678ed;
  font-family: "Poppins-Bold", Helvetica;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 0;
  line-height: normal;
  margin-top: -1.00px;
  position: relative;
  width: fit-content;
`;

const GroupWrapper = styled.div`
  align-items: flex-end;
  display: flex;
  height: 184px;
  left: 24px;
  min-width: 406px;
  overflow-x: scroll;
  position: absolute;
  top: 587px;

  &::-webkit-scrollbar {
    display: none;
    width: 0;
  }
`;

const Group = styled.div`
  display: flex;
  flex: 0 0 auto;
  gap: 4px;
  height: 184px;
  margin-bottom: -0.39px;
  width: 996px;
`;

const Group2 = styled.div`
  height: 184.39px;
  position: relative;
  width: 163.62px;
`;

const Rectangle2 = styled.div`
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
`;

const Polygon = styled.img`
  aspect-ratio: 1;
  height: 25px;
  left: 114px;
  position: absolute;
  top: 150px;
  width: 25px;
`;

const TextWrapper2 = styled.div`
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
`;

const TextWrapper3 = styled.div`
  color: #3d348b;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 15px;
  font-weight: 400;
  left: 43px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 79px;
`;

const TextWrapper4 = styled.div`
  color: #282257;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 15px;
  font-weight: 400;
  left: 97px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 149px;
`;

const Rectangle3 = styled.div`
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
  left: 0;
  position: absolute;
  top: 0;
  width: 158px;
`;

const TextWrapper5 = styled.div`
  color: #282257;
  font-family: "Poppins-Regular", Helvetica;
  font-size: 15px;
  font-weight: 400;
  left: 91px;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 148px;
`;

const Background = styled.img`
  aspect-ratio: 0.94;
  height: 309px;
  left: 0;
  position: absolute;
  top: 0;
  width: 430px;
`;

const StreakSection = styled.div`
  box-shadow: 0px 4px 4px #00000040;
  display: flex;
  flex-direction: column;
  gap: 18px;
  height: 288px;
  left: 24px;
  position: absolute;
  top: 165px;
  width: 383px;
`;

const Group3 = styled.div`
  height: 36px;
  margin-left: 43.6px;
  position: relative;
  width: 114.41px;
`;

const TextWrapper6 = styled.div`
  color: #ffffff;
  font-family: "Poppins-Bold", Helvetica;
  font-size: 24px;
  font-weight: 700;
  left: 0;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 0;
  width: 84px;
`;

const Vector = styled.img`
  aspect-ratio: 0.75;
  height: 25px;
  left: 81.64%;
  position: absolute;
  top: calc(50.00% - 13px);
  width: 16.61%;
`;

const Rectangle4 = styled.div`
  background-color: #f8f9fa;
  border-radius: 32px;
  height: 234px;
`;

const StatusBar = styled.div`
  height: 2.25%;
  left: 10.47%;
  position: absolute;
  top: 2.47%;
  width: 81.86%;
`;

const TextWrapper7 = styled.div`
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

const Vector2 = styled.img`
  height: 43.86%;
  left: 94.20%;
  position: absolute;
  top: 24.56%;
  width: 5.23%;
`;

const Vector3 = styled.img`
  height: 61.40%;
  left: 86.66%;
  position: absolute;
  top: 7.02%;
  width: 5.23%;
`;

const Vector4 = styled.img`
  height: 70.18%;
  left: 79.55%;
  position: absolute;
  top: 0;
  width: 4.84%;
`;

const Header = styled.header`
  background-color: transparent;
  height: 39px;
  left: 16px;
  position: absolute;
  top: 76px;
  width: 390px;
`;

const Vector5 = styled.img`
  height: 24px;
  left: 367px;
  position: absolute;
  top: 8px;
  width: 23px;
`;

const Logo = styled.div`
  aspect-ratio: 3.23;
  height: 100%;
  left: 0;
  position: absolute;
  top: 0;
  width: 32.80%;
`;

const TextWrapper8 = styled.div`
  color: #ffffff;
  font-family: "Poppins-Bold", Helvetica;
  font-size: 28px;
  font-weight: 700;
  height: 100%;
  left: 33.59%;
  letter-spacing: 0;
  line-height: normal;
  position: absolute;
  top: 0;
  width: 64.84%;
`;

const Vector6 = styled.img`
  aspect-ratio: 1.12;
  height: 32px;
  left: 0;
  position: absolute;
  top: calc(50.00% - 16px);
  width: 28.12%;
`;

const Calendar = styled.div`
  aspect-ratio: 1.77;
  height: 188px;
  left: 52px;
  position: absolute;
  top: 242px;
  width: 334px;
`;

const CircleStyled = styled(Circle)`
  aspect-ratio: 1 !important;
  height: 25px !important;
  position: absolute !important;
  width: 25px !important;
`;

const Property1Active = styled(CircleStyled)`
  left: 0 !important;
  top: 0 !important;
`;

const Property1Default = styled(CircleStyled)`
  left: 52px !important;
  top: 0 !important;
`;

const CircleInstance = styled(CircleStyled)`
  left: 103px !important;
  top: 0 !important;
`;

const Property1ActiveInstance = styled(CircleStyled)`
  left: 155px !important;
  top: 0 !important;
`;

const Property1DefaultInstance = styled(CircleStyled)`
  left: 206px !important;
  top: 0 !important;
`;

const IconInstanceNode = styled(CircleStyled)`
  left: 258px !important;
  top: 0 !important;
`;

const Circle2 = styled(CircleStyled)`
  left: 309px !important;
  top: 0 !important;
`;

const Circle3 = styled(CircleStyled)`
  left: 0 !important;
  top: 41px !important;
`;

const Circle4 = styled(CircleStyled)`
  left: 52px !important;
  top: 41px !important;
`;

const Circle5 = styled(CircleStyled)`
  left: 103px !important;
  top: 41px !important;
`;

const Circle6 = styled(CircleStyled)`
  left: 155px !important;
  top: 41px !important;
`;

const Circle7 = styled(CircleStyled)`
  left: 206px !important;
  top: 41px !important;
`;

const Circle8 = styled(CircleStyled)`
  left: 258px !important;
  top: 41px !important;
`;

const Circle9 = styled(CircleStyled)`
  left: 309px !important;
  top: 41px !important;
`;

const Circle10 = styled(CircleStyled)`
  left: 0 !important;
  top: 82px !important;
`;

const Circle11 = styled(CircleStyled)`
  left: 52px !important;
  top: 82px !important;
`;

const Circle12 = styled(CircleStyled)`
  left: 103px !important;
  top: 82px !important;
`;

const Circle13 = styled(CircleStyled)`
  left: 155px !important;
  top: 82px !important;
`;

const Circle14 = styled(CircleStyled)`
  left: 206px !important;
  top: 82px !important;
`;

const Circle15 = styled(CircleStyled)`
  left: 258px !important;
  top: 82px !important;
`;

const Circle16 = styled(CircleStyled)`
  left: 309px !important;
  top: 82px !important;
`;

const Circle17 = styled(CircleStyled)`
  left: 0 !important;
  top: 123px !important;
`;

const Circle18 = styled(CircleStyled)`
  left: 52px !important;
  top: 123px !important;
`;

const Circle19 = styled(CircleStyled)`
  left: 103px !important;
  top: 123px !important;
`;

const Circle20 = styled(CircleStyled)`
  left: 155px !important;
  top: 123px !important;
`;

const Circle21 = styled(CircleStyled)`
  left: 206px !important;
  top: 123px !important;
`;

const Circle22 = styled(CircleStyled)`
  left: 258px !important;
  top: 123px !important;
`;

const Circle23 = styled(CircleStyled)`
  left: 309px !important;
  top: 123px !important;
`;

const Circle24 = styled(CircleStyled)`
  left: 0 !important;
  top: 163px !important;
`;

const Circle25 = styled(CircleStyled)`
  left: 52px !important;
  top: 163px !important;
`;

const Circle26 = styled(CircleStyled)`
  left: 103px !important;
  top: 163px !important;
`;

const NavBarInstance = styled(NavBar)`
  bottom: 0 !important;
  left: 0 !important;
  position: absolute !important;
  top: unset !important;
`;

export const Homepage = () => {
  return (
    <StyledHomepage>
      <RecentDecksSection>
        <TextWrapper>Recent Decks</TextWrapper>
        <Frame>
          <Div>See all</Div>
        </Frame>
      </RecentDecksSection>

      <GroupWrapper>
        <Group>
          <Group2>
            <Rectangle2 />
            <Polygon alt="Polygon" src={polygon1} />
            <TextWrapper2>Japanese</TextWrapper2>
            <TextWrapper3>126 cards</TextWrapper3>
            <TextWrapper4>36</TextWrapper4>
          </Group2>

          <Group2>
            <Rectangle2 />
            <Polygon alt="Polygon" src={image} />
            <TextWrapper2>CCNA</TextWrapper2>
            <TextWrapper3>84 cards</TextWrapper3>
            <TextWrapper4>12</TextWrapper4>
          </Group2>

          <Group2>
            <Rectangle3 />
            <Polygon alt="Polygon" src={polygon12} />
            <TextWrapper2>AI</TextWrapper2>
            <TextWrapper3>21 cards</TextWrapper3>
            <TextWrapper4>0</TextWrapper4>
          </Group2>

          <Group2>
            <Rectangle3 />
            <Polygon alt="Polygon" src={polygon13} />
            <TextWrapper2>OOP</TextWrapper2>
            <TextWrapper3>100 cards</TextWrapper3>
            <TextWrapper5>54</TextWrapper5>
          </Group2>

          <Group2>
            <Rectangle3 />
            <Polygon alt="Polygon" src={polygon14} />
            <TextWrapper2>Logic</TextWrapper2>
            <TextWrapper3>126 cards</TextWrapper3>
            <TextWrapper4>36</TextWrapper4>
          </Group2>

          <Group2>
            <Rectangle3 />
            <Polygon alt="Polygon" src={polygon15} />
            <TextWrapper2>Biology</TextWrapper2>
            <TextWrapper3>no cards</TextWrapper3>
            <TextWrapper4>0</TextWrapper4>
          </Group2>
        </Group>
      </GroupWrapper>

      <Background alt="Background" src={background} />

      <StreakSection>
        <Group3>
          <TextWrapper6>Streak</TextWrapper6>
          <Vector alt="Vector" src={vector1} />
        </Group3>
        <Rectangle4 />
      </StreakSection>

      <StatusBar>
        <TextWrapper7>9:41</TextWrapper7>
        <Vector2 alt="Vector" src={vector2} />
        <Vector3 alt="Vector" src={vector3} />
        <Vector4 alt="Vector" src={vector4} />
      </StatusBar>

      <Header>
        <Vector5 alt="Vector" src={vector5} />
        <Logo>
          <TextWrapper8>Kioku</TextWrapper8>
          <Vector6 alt="Vector" src={vector} />
        </Logo>
      </Header>

      <Calendar>
        <Property1Active />
        <Property1Default />
        <CircleInstance />
        <Property1ActiveInstance />
        <Property1DefaultInstance />
        <IconInstanceNode />
        <Circle2 />
        <Circle3 />
        <Circle4 />
        <Circle5 />
        <Circle6 />
        <Circle7 />
        <Circle8 />
        <Circle9 />
        <Circle10 />
        <Circle11 />
        <Circle12 />
        <Circle13 />
        <Circle14 />
        <Circle15 />
        <Circle16 />
        <Circle17 />
        <Circle18 />
        <Circle19 />
        <Circle20 />
        <Circle21 />
        <Circle22 />
        <Circle23 />
        <Circle24 />
        <Circle25 />
        <Circle26 />
      </Calendar>

      <NavBarInstance
        className="nav-bar-instance"
        img="default-4.svg"
        property1="home-default"
        vectorDefault="default-3.svg"
        vectorDefault1="default-5.svg"
      />
    </StyledHomepage>
  );
};
