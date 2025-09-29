import {
  View,
  Text,
  ScrollView,
  Image,
  StyleSheet,
  Touchable,
  TouchableOpacity,
  TextInput,
} from "react-native";
import React, { useState } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import images from "@/constants/images";

const SignIn = () => {
  const [mode, setMode] = useState("default");

  return (
    <SafeAreaView className="bg-steel-400 h-full" style={styles.rootContainer}>
      <View style={styles.circleBackground} />
      <Text style={styles.screenTitle}>Account</Text>
      <ScrollView
        contentContainerClassName="h-full"
        contentContainerStyle={styles.scrollContainer}
      >
        <View style={styles.card}>
          {mode === "default" && (
            <>
              {/*SIGN IN BUTTON*/}
              <TouchableOpacity
                style={styles.signInButton}
                onPress={() => setMode("signin")}
              >
                <Text style={styles.signInText}>Sign In</Text>
              </TouchableOpacity>

              {/*SIGN UP BUTTON*/}
              <TouchableOpacity
                style={styles.signUpButton}
                onPress={() => setMode("signup")}
              >
                <Text style={styles.signUpText}>Sign Up</Text>
              </TouchableOpacity>
            </>
          )}
          {mode === "signin" && (
            <>
              {/*SIGN IN FORM*/}
              <TextInput
                placeholder="Email"
                style={styles.input}
                keyboardType="email-address"
              />
              <TextInput
                placeholder="Password"
                style={styles.input}
                secureTextEntry
              />
              <TouchableOpacity style={styles.signInButton}>
                <Text style={styles.signInText}>Login</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.cancelButton}
                onPress={() => setMode("default")}
              >
                <Text style={styles.cancelText}>Cancel</Text>
              </TouchableOpacity>
            </>
          )}

          {mode === "signup" && (
            <>
              {/* Sign up form */}
              <TextInput placeholder="Name" style={styles.input} />
              <TextInput
                placeholder="Email"
                style={styles.input}
                keyboardType="email-address"
              />
              <TextInput
                placeholder="Password"
                style={styles.input}
                secureTextEntry
              />
              <TextInput
                placeholder="Confirm Password"
                style={styles.input}
                secureTextEntry
              />
              <TouchableOpacity style={styles.signUpButtonFilled}>
                <Text style={styles.signInText}>Create Account</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={styles.cancelButton}
                onPress={() => setMode("default")}
              >
                <Text style={styles.cancelText}>Cancel</Text>
              </TouchableOpacity>
            </>
          )}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

function handleLogin() {}

function HomeScreen() {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>🏠 Home</Text>
    </View>
  );
}

function AccountScreen() {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>👤 Account</Text>
    </View>
  );
}

function AddScreen() {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>"+" Settings</Text>
    </View>
  );
}

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
    height: "60%",
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

  input: {
    width: "100%",
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 8,
    padding: 12,
    marginBottom: 15,
  },

  cancelButton: {
    marginTop: 10,
    paddingVertical: 10,
    paddingHorizontal: 20,
  },
  cancelText: {
    color: "#999",
    fontSize: 14,
    fontWeight: "500",
  },

  signUpButtonFilled: {
    backgroundColor: "#3a2fa3",
    paddingVertical: 12,
    paddingHorizontal: 30,
    borderRadius: 8,
    marginTop: 10,
  },
});

export default SignIn;
