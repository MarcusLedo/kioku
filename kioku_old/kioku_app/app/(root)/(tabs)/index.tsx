import { Link } from "expo-router";
import { Text, View } from "react-native";

export default function Index() {
  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <Text className=" my-10 text-3xl font-rubik">Welcome to Kioku</Text>
      <Link href="./sign_in">Sign In</Link>
      <Link href="./profile">Profile</Link>
      <Link href="./properties/1">Property</Link>
    </View>
  );
}
