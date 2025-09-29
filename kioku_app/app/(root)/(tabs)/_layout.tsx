import { View, Text, Image } from "react-native";
import React from "react";
import { Tabs } from "expo-router";

import icons from "@/constants/icons";

const TabIcon = ({
  focused,
  icon,
  title,
}: {
  focused: boolean;
  icon: any;
  title: string;
}) => {
  return (
    <View className="flex-1 mt-3 flex flex-col items-center">
      <Image
        source={icon}
        resizeMode="contain"
        className="size-6"
        style={{
          width: 24,
          height: 24,
          tintColor: focused ? "#7678ED" : "#999",
        }}
      />
    </View>
  );
};

const TabsLayout = () => {
  return (
    <Tabs
      screenOptions={{
        tabBarShowLabel: false,
        tabBarStyle: {
          backgroundColor: "white",
          position: "absolute",
          borderTopColor: "#0061FF1A",
          borderTopWidth: 1,
          minHeight: 70,
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: "Home",
          headerShown: false,
          tabBarIcon: ({ focused }) => (
            <TabIcon icon={icons.home} focused={focused} title="Home" />
          ),
        }}
      />

      <Tabs.Screen
        name="profile"
        options={{
          title: "Home",
          headerShown: false,
          tabBarIcon: ({ focused }) => (
            <TabIcon icon={icons.add2} focused={focused} title="Home" />
          ),
        }}
      />

      <Tabs.Screen
        name="sign_in"
        options={{
          title: "sign_in",
          headerShown: false,
          tabBarIcon: ({ focused }) => (
            <TabIcon icon={icons.person} focused={focused} title="Home" />
          ),
        }}
      />
    </Tabs>
  );
};

export default TabsLayout;
