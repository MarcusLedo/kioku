import React, { useState } from "react";
import {
  View,
  Text,
  Modal,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
} from "react-native";
import { Deck } from "../screens/deckListScreen";
import { Ionicons } from "@expo/vector-icons";

interface Props {
  deck: Deck;
  decks: Deck[];
  onClose: () => void;
  onSaved: (deck: Deck) => void;
}

export default function EditDeckModal({
  deck,
  decks,
  onClose,
  onSaved,
}: Props) {
  const [name, setName] = useState(deck.name);

  const invalidChars = /[\/,%$]/;

  function handleSave() {
    if (!name.trim()) {
      Alert.alert("Nome inválido", "O campo nome é obrigatório.");
      return;
    }

    if (invalidChars.test(name)) {
      Alert.alert(
        "Caractere inválido",
        "O nome contém caracteres proibidos: / , % $"
      );
      return;
    }

    const exists = decks.some(
      (d) => d.name.toLowerCase() === name.toLowerCase() && d.id !== deck.id
    );

    if (exists) {
      Alert.alert("Nome duplicado", "Já existe um deck com esse nome.");
      return;
    }

    const updatedDeck = { ...deck, name };

    // TODO: enviar ao backend
    // await api.updateDeck(updatedDeck)

    onSaved(updatedDeck);
  }

  return (
    <Modal transparent animationType="fade">
      <View style={styles.overlay}>
        <View style={styles.modalBox}>
          <View style={styles.header}>
            <Text style={styles.title}>Renomear Deck</Text>

            <TouchableOpacity onPress={onClose}>
              <Ionicons name="close" size={24} color="#000" />
            </TouchableOpacity>
          </View>

          <Text style={styles.label}>Novo nome</Text>

          <TextInput
            value={name}
            onChangeText={setName}
            placeholder="Digite o novo nome..."
            placeholderTextColor="#777"
            style={styles.input}
          />

          <View style={styles.buttonRow}>
            <TouchableOpacity style={styles.cancelButton} onPress={onClose}>
              <Text style={styles.cancelText}>Cancelar</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.saveButton} onPress={handleSave}>
              <Text style={styles.saveText}>Salvar</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.35)",
    justifyContent: "center",
    alignItems: "center",
  },
  modalBox: {
    width: "85%",
    backgroundColor: "#fff",
    padding: 20,
    borderRadius: 16,
    elevation: 10,
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 14,
  },
  title: {
    fontSize: 22,
    fontWeight: "bold",
  },
  label: {
    color: "#333",
    marginBottom: 6,
    marginTop: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 8,
    padding: 10,
    fontSize: 16,
    marginBottom: 20,
  },
  buttonRow: {
    flexDirection: "row",
    justifyContent: "space-between",
  },
  cancelButton: {
    paddingVertical: 10,
    paddingHorizontal: 20,
  },
  cancelText: {
    fontSize: 16,
    color: "#777",
  },
  saveButton: {
    backgroundColor: "#0096C7",
    paddingVertical: 10,
    paddingHorizontal: 24,
    borderRadius: 8,
  },
  saveText: {
    fontSize: 16,
    color: "#fff",
    fontWeight: "bold",
  },
});
