import { View, Text, ScrollView, Image } from "react-native";
import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import images from "@/constants/images";

const SignIn = () => {
  return (
    <SafeAreaView className="bg-white h-full">
      <Image
        source={images.background}
        className="w-full"
        resizeMode="contain"
      />
      <ScrollView contentContainerClassName="h-full">
        <Text>Sign In</Text>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SignIn;
