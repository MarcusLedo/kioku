import React from "react";
import { View, TextInput, StyleSheet } from "react-native";
import { Ionicons } from "@expo/vector-icons";

interface Props {
  value: string;
  onChange: (text: string) => void;
}

export default function SearchBar({ value, onChange }: Props) {
  return (
    <View style={styles.container}>
      <Ionicons name="search" size={20} color="#555" />

      <TextInput
        style={styles.input}
        placeholder="Pesquisar por deck..."
        placeholderTextColor="#777"
        value={value}
        onChangeText={onChange}
      />

      <Ionicons name="add-circle-outline" size={24} color="#000" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    backgroundColor: "#fff",
    padding: 10,
    borderRadius: 12,
    alignItems: "center",
    marginBottom: 20,
  },
  input: {
    flex: 1,
    marginHorizontal: 10,
    fontSize: 16,
  },
});
