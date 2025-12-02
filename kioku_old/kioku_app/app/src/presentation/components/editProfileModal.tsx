import React, { useState } from "react";
import {
  Modal,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
} from "react-native";

export interface User {
  id: number;
  name: string;
  email: string;
  phone: string;
}

interface Props {
  user: User;
  onClose: () => void;
  onSave: (updatedUser: User) => void;
}

export default function EditProfileModal({ user, onClose, onSave }: Props) {
  const [name, setName] = useState(user.name);
  const [email, setEmail] = useState(user.email);
  const [phone, setPhone] = useState(user.phone);
  const [password, setPassword] = useState("");

  // Mock de e-mails já usados
  const existingEmails = ["teste@gmail.com", "flavia@example.com"];

  function validatePassword(pwd: string) {
    return pwd.length >= 6;
  }

  function handleSave() {
    if (!name.trim() || !email.trim() || !phone.trim()) {
      Alert.alert("Erro", "Todos os campos obrigatórios devem ser preenchidos.");
      return;
    }

    if (email !== user.email && existingEmails.includes(email)) {
      Alert.alert("Erro", "Este e-mail já está cadastrado.");
      return;
    }

    if (password && !validatePassword(password)) {
      Alert.alert("Senha fraca", "A senha deve ter pelo menos 6 caracteres.");
      return;
    }

    const updatedUser: User = {
      ...user,
      name,
      email,
      phone,
      // senha só é enviada se for alterada
    };

    // TODO: chamada ao backend para atualizar perfil
    // await api.updateProfile(updatedUser, password)

    onSave(updatedUser);
  }

  return (
    <Modal transparent animationType="fade">
      <View style={styles.overlay}>
        <View style={styles.modalBox}>
          <Text style={styles.title}>Editar Perfil</Text>

          <Text style={styles.label}>Nome *</Text>
          <TextInput
            style={styles.input}
            value={name}
            onChangeText={setName}
          />

          <Text style={styles.label}>E-mail *</Text>
          <TextInput
            style={styles.input}
            value={email}
            autoCapitalize="none"
            onChangeText={setEmail}
          />

          <Text style={styles.label}>Telefone *</Text>
          <TextInput
            style={styles.input}
            value={phone}
            keyboardType="phone-pad"
            onChangeText={setPhone}
          />

          <Text style={styles.label}>Senha (opcional)</Text>
          <TextInput
            style={styles.input}
            secureTextEntry
            placeholder="••••••"
            value={password}
            onChangeText={setPassword}
          />

          <View style={styles.buttons}>
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
    backgroundColor: "rgba(0,0,0,0.4)",
    justifyContent: "center",
    alignItems: "center",
  },
  modalBox: {
    width: "85%",
    backgroundColor: "#fff",
    padding: 20,
    borderRadius: 15,
  },
  title: {
    fontSize: 22,
    fontWeight: "bold",
    marginBottom: 15,
  },
  label: {
    marginVertical: 6,
    fontWeight: "600",
    color: "#333",
  },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    borderColor: "#ccc",
    padding: 10,
    marginBottom: 5,
  },
  buttons: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginTop: 18,
  },
  cancelButton: {
    padding: 12,
  },
  cancelText: {
    color: "#777",
    fontSize: 16,
  },
  saveButton: {
    backgroundColor: "#0096C7",
    paddingVertical: 12,
    paddingHorizontal: 20,
    borderRadius: 8,
  },
  saveText: {
    color: "white",
    fontWeight: "bold",
    fontSize: 16,
  },
});
