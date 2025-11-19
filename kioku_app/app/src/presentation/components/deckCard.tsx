import React from "react";
import { View, Text, StyleSheet, TouchableOpacity } from "react-native";
import { Ionicons } from "@expo/vector-icons";
import { Deck } from "../screens/deckListScreen";

interface Props {
  deck: Deck;
}

export default function DeckCard({ deck }: Props) {
  const cardColor = deck.shared ? "#00B4D8" : "#0096C7";

  return (
    <TouchableOpacity style={[styles.card, { backgroundColor: cardColor }]}>
      <View style={styles.iconWrapper}>
        <Ionicons
          name={deck.shared ? "people" : "book"}
          size={32}
          color="#fff"
        />
      </View>

      <Text style={styles.deckName}>{deck.name}</Text>

      <View style={styles.footer}>
        <Text style={styles.footerText}>{deck.total}</Text>
        <Ionicons name="warning" size={14} color="yellow" />
        <Text style={styles.footerText}>{deck.due}</Text>
      </View>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    width: "48%",
    padding: 18,
    borderRadius: 14,
    marginBottom: 18,
  },
  iconWrapper: {
    alignItems: "flex-start",
    marginBottom: 12,
  },
  deckName: {
    fontSize: 18,
    fontWeight: "600",
    color: "#fff",
    marginBottom: 14,
  },
  footer: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  footerText: {
    fontSize: 14,
    color: "#fff",
  },
});
