import {
  View,
  Text,
  ScrollView,
  Image,
  StyleSheet,
  Touchable,
  TouchableOpacity,
} from "react-native";
import React from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import images from "@/constants/images";

const SignIn = () => {
  return (
    <SafeAreaView className="bg-steel-400 h-full" style={styles.rootContainer}>
      <View style={styles.circleBackground} />
      <Text style={styles.screenTitle}>Account</Text>
      <ScrollView
        contentContainerClassName="h-full"
        contentContainerStyle={styles.scrollContainer}
      >
        <View style={styles.card}>
          {/*SIGN IN BUTTON*/}
          <TouchableOpacity style={styles.signInButton}>
            <Text style={styles.signInText}>Sign In</Text>
          </TouchableOpacity>

          {/*SIGN UP BUTTON*/}
          <TouchableOpacity style={styles.signUpButton}>
            <Text style={styles.signUpText}>Sign Up</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  rootContainer: {
    overflow: "visible",
  },

  scrollContainer: {
    flexGrow: 1,
    justifyContent: "center",
    alignItems: "center",
  },

  circleBackground: {
    position: "absolute",
    width: 1000,
    height: 1000,
    borderRadius: 500,
    backgroundColor: "#3a2fa3",
    top: -600,
    left: -550,
  },

  screenTitle: {
    color: "#fff",
    fontSize: 24,
    fontWeight: "700",
    marginTop: 40,
    marginLeft: 20,
  },

  card: {
    backgroundColor: "#fff",
    width: "80%",
    height: "40%",
    borderRadius: 20,
    padding: 25,
    alignItems: "center",
    justifyContent: "center",
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.15,
    shadowRadius: 10,
    elevation: 5,
  },

  signInButton: {
    backgroundColor: "#3a2fa3",
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 8,
    marginBottom: 15,
  },
  signInText: {
    color: "#fff",
    fontSize: 16,
    fontWeight: "600",
  },
  signUpButton: {
    borderWidth: 1,
    borderColor: "#3a2fa3",
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 8,
  },
  signUpText: {
    color: "#3a2fa3",
    fontSize: 16,
    fontWeight: "600",
  },
});

export default SignIn;
