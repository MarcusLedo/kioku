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
  onClose: () => void;
  onSave: (updatedDeck: Deck) => void;
}

export default function EditDeckModal({ deck, onClose, onSave }: Props) {
  const [name, setName] = useState(deck.name);

  function handleSave() {
    if (!name.trim()) {
      Alert.alert("Nome inválido", "O campo nome é obrigatório.");
      return;
    }

    const invalidChars = /[\/,%$]/;
    if (invalidChars.test(name)) {
      Alert.alert("Caractere inválido", "O nome contém caracteres proibidos.");
      return;
    }

    const updatedDeck = { ...deck, name };
    onSave(updatedDeck);
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
            style={styles.input}
          />

          <View style={styles.buttonRow}>
            <TouchableOpacity onPress={onClose}>
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
  overlay: { flex: 1, backgroundColor: "rgba(0,0,0,0.35)", justifyContent: "center", alignItems: "center" },
  modalBox: { width: "85%", backgroundColor: "#fff", padding: 20, borderRadius: 16 },
  header: { flexDirection: "row", justifyContent: "space-between", marginBottom: 14 },
  title: { fontSize: 22, fontWeight: "bold" },
  label: { marginBottom: 6 },
  input: { borderWidth: 1, borderColor: "#ccc", borderRadius: 8, padding: 10, fontSize: 16 },
  buttonRow: { flexDirection: "row", justifyContent: "space-between", marginTop: 20 },
  cancelText: { fontSize: 16, color: "#777" },
  saveButton: { backgroundColor: "#0096C7", paddingVertical: 10, paddingHorizontal: 24, borderRadius: 8 },
  saveText: { color: "#fff", fontWeight: "bold" },
});
