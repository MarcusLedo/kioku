import React, { useState, useEffect } from "react";
import { View, Text, TouchableOpacity, FlatList, StyleSheet } from "react-native";
import { Pencil, X, Plus } from "lucide-react-native";
import EditDeckModal from "../components/editDeckModal";
import { Deck } from "./deckListScreen";
import { useRoute } from "@react-navigation/native";

interface Card {
  id: number;
  question: string;
  answer?: string;
  createdAt: string;
}

export default function DeckDetailsScreen() {
  const route = useRoute<any>();
  const initialDeck: Deck = route.params?.deck;

  const [deck, setDeck] = useState<Deck>(initialDeck);
  const [cards, setCards] = useState<Card[]>([]);
  const [showEditPopup, setShowEditPopup] = useState(false);

  useEffect(() => {
    // TODO integrar com backend usando deck.id
    const mockCards = [
      { id: 1, question: "Qual é o símbolo do sódio?", createdAt: "2025-01-05" },
      { id: 2, question: "Qual gás é essencial para a respiração?", createdAt: "2025-01-01" },
      { id: 3, question: "Qual é o pH da água pura?", createdAt: "2025-01-03" },
    ];

    const sorted = mockCards.sort(
      (a, b) => new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime()
    );

    setCards(sorted);
  }, [deck.id]);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity>
          <Text style={styles.backText}>Voltar</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={() => setShowEditPopup(true)}>
          <Pencil size={28} color="white" />
        </TouchableOpacity>
      </View>

      <Text style={styles.title}>{deck.name}</Text>

      <View style={styles.cardsHeader}>
        <Text style={styles.cardsTitle}>Cards</Text>
        <TouchableOpacity style={styles.addButton}>
          <Plus size={22} color="white" />
        </TouchableOpacity>
      </View>

      <FlatList
        data={cards}
        keyExtractor={(item: Deck) => item.id.toString()}
        renderItem={({ item, index }: { item: Card; index: number }) => (
          <View style={styles.card}>
            <Text style={styles.cardText}>
              {index + 1}. {item.question}
            </Text>
            <View style={styles.cardActions}>
              <Pencil size={20} color="#0d9488" />
              <X size={20} color="#dc2626" />
            </View>
          </View>
        )}
      />

      {showEditPopup && (
        <EditDeckModal
          deck={deck}
          onClose={() => setShowEditPopup(false)}
          onSave={(updatedDeck) => {
            setDeck(updatedDeck);
          }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16, backgroundColor: "#f4f4f5" },
  header: {
    backgroundColor: "#0d9488",
    padding: 20,
    borderBottomLeftRadius: 20,
    borderBottomRightRadius: 20,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  backText: { color: "white", fontSize: 16 },
  title: {
    fontSize: 28,
    fontWeight: "bold",
    marginTop: 12,
    textAlign: "center",
    color: "#0d9488",
  },
  cardsHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: 20,
  },
  cardsTitle: { fontSize: 20, fontWeight: "600" },
  addButton: { backgroundColor: "#0d9488", padding: 10, borderRadius: 50 },
  card: {
    backgroundColor: "white",
    padding: 14,
    borderRadius: 12,
    marginVertical: 6,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  cardText: { color: "#374151", flex: 1 },
  cardActions: { flexDirection: "row", gap: 12 },
});
