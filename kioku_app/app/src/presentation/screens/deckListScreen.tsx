import React, { useState, useEffect } from "react";
import { View, Text, FlatList, StyleSheet } from "react-native";
import SearchBar from "../components/searchBar";
import DeckCard from "../components/deckCard";

export interface Deck {
  id: number;
  name: string;
  total: number;
  due: number;
  shared: boolean;
}

export default function DeckListScreen() {
  const [search, setSearch] = useState<string>("");
  const [decks, setDecks] = useState<Deck[]>([]);

  useEffect(() => {
    // TODO: fazer chamada ao backend
    const mockDecks: Deck[] = [
      { id: 1, name: "Japonês", total: 126, due: 36, shared: false },
      { id: 2, name: "Matemática", total: 5, due: 20, shared: true },
      { id: 3, name: "Português", total: 20, due: 5, shared: false },
      { id: 4, name: "Biologia", total: 50, due: 10, shared: true },
      { id: 5, name: "História", total: 70, due: 12, shared: false },
    ];

    const sorted = [...mockDecks].sort((a, b) =>
      a.name.localeCompare(b.name)
    );

    setDecks(sorted);
  }, []);

  const filteredDecks = decks.filter((deck: Deck) =>
    deck.name.toLowerCase().includes(search.toLowerCase())
  );

  const renderEmpty = () => (
    <View style={styles.emptyContainer}>
      <Text style={styles.emptyText}>Nenhum deck disponível.</Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Decks</Text>

      <SearchBar value={search} onChange={setSearch} />

      {filteredDecks.length === 0 ? (
        renderEmpty()
      ) : (
        <FlatList
          data={filteredDecks}
          keyExtractor={(item: Deck) => item.id.toString()}
          numColumns={2}
          columnWrapperStyle={styles.column}
          contentContainerStyle={{ paddingBottom: 20 }}
          renderItem={({ item }: { item: Deck }) => <DeckCard deck={item} />}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#E6EEF2",
    paddingHorizontal: 16,
    paddingTop: 50,
  },
  title: {
    fontSize: 26,
    fontWeight: "bold",
    color: "#000",
    marginBottom: 16,
  },
  column: {
    justifyContent: "space-between",
  },
  emptyContainer: {
    marginTop: 40,
    alignItems: "center",
  },
  emptyText: {
    fontSize: 16,
    color: "#444",
  },
});
