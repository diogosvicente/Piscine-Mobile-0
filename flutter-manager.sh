#!/bin/bash
# Gerenciador de ambiente Flutter/Android no /goinfre/$USER (42)

BASE_DIR="/goinfre/$USER"
FLUTTER_VERSION="3.35.3"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

FLUTTER_DIR="$BASE_DIR/flutter"
ANDROID_SDK_DIR="$BASE_DIR/android-sdk"
ANDROID_SDK_TOOLS_DIR="$ANDROID_SDK_DIR/cmdline-tools/latest"
AVD_HOME="$BASE_DIR/.android/avd"

AVD_NAME="Pixel_4_API_35"
AVD_PACKAGE="system-images;android-35;google_apis;x86_64"

ZSHRC="$HOME/.zshrc"

create_folders() {
    echo "==> Criando estrutura de pastas em $BASE_DIR ..."
    mkdir -p "$FLUTTER_DIR" "$ANDROID_SDK_DIR/cmdline-tools" "$AVD_HOME"
    echo "✅ Estrutura criada."
}

setup_env() {
    echo "==> Configurando variáveis de ambiente..."
    export PATH="$FLUTTER_DIR/bin:$PATH"
    export ANDROID_SDK_ROOT="$ANDROID_SDK_DIR"
    export PATH="$ANDROID_SDK_TOOLS_DIR/bin:$PATH"
    export PATH="$ANDROID_SDK_DIR/platform-tools:$PATH"
    export PATH="$ANDROID_SDK_DIR/emulator:$PATH"
    export ANDROID_AVD_HOME="$AVD_HOME"

    if ! grep -q "flutter/bin" "$ZSHRC"; then
        echo "==> Adicionando variáveis ao ~/.zshrc..."
        cat <<EOL >> "$ZSHRC"

# >>> Flutter & Android SDK (42 goinfre setup) >>>
export PATH="/goinfre/\$USER/flutter/bin:\$PATH"
export ANDROID_SDK_ROOT="/goinfre/\$USER/android-sdk"
export PATH="/goinfre/\$USER/android-sdk/cmdline-tools/latest/bin:\$PATH"
export PATH="/goinfre/\$USER/android-sdk/platform-tools:\$PATH"
export PATH="/goinfre/\$USER/android-sdk/emulator:\$PATH"
export ANDROID_AVD_HOME="/goinfre/\$USER/.android/avd"
# <<< Flutter & Android SDK <<<
EOL
    fi
}

install_sdks() {
    setup_env

    # Flutter
    if [ ! -d "$FLUTTER_DIR/bin" ]; then
        echo "⚠️ Instalando Flutter SDK..."
        cd "$BASE_DIR" || exit 1
        wget -q --show-progress "$FLUTTER_URL" -O flutter.tar.xz
        tar -xf flutter.tar.xz && rm flutter.tar.xz
        echo "✅ Flutter SDK instalado em $FLUTTER_DIR"
    else
        echo "ℹ️ Flutter SDK já existe em $FLUTTER_DIR"
    fi

    # Android cmdline-tools
    if [ ! -d "$ANDROID_SDK_TOOLS_DIR" ]; then
        echo "⚠️ Instalando Android cmdline-tools..."
        mkdir -p "$ANDROID_SDK_DIR/cmdline-tools"
        cd "$ANDROID_SDK_DIR/cmdline-tools" || exit 1
        wget -q --show-progress "$ANDROID_SDK_URL" -O cmdline-tools.zip
        unzip -q cmdline-tools.zip && rm cmdline-tools.zip
        mv cmdline-tools latest
        echo "✅ Android cmdline-tools instalado"
    else
        echo "ℹ️ Android cmdline-tools já existem"
    fi

    # Pacotes básicos
    echo "==> Instalando pacotes do Android SDK..."
    yes | sdkmanager --install \
        "platform-tools" \
        "platforms;android-35" \
        "build-tools;35.0.0" \
        "emulator" \
        "$AVD_PACKAGE"

    # Licenças
    echo "==> Aceitando licenças..."
    yes | sdkmanager --licenses

    # AVD
    if ! avdmanager list avd | grep -q "$AVD_NAME"; then
        echo "⚠️ Criando AVD '$AVD_NAME'..."
        echo "no" | avdmanager create avd -n "$AVD_NAME" -k "$AVD_PACKAGE" --device "pixel_4" --force
        echo "✅ AVD criado em $AVD_HOME/$AVD_NAME"
    else
        echo "ℹ️ AVD '$AVD_NAME' já existe"
    fi

    flutter doctor
}

start_emulator() {
    setup_env
    echo "==> Verificando se o AVD '$AVD_NAME' existe em $AVD_HOME..."
    if avdmanager list avd | grep -q "$AVD_NAME"; then
        echo "✅ Iniciando emulador $AVD_NAME..."
        nohup emulator -avd "$AVD_NAME" -netdelay none -netspeed full > /dev/null 2>&1 &
        echo "ℹ️ O emulador está iniciando em segundo plano."
        echo "   Use 'adb devices' para verificar."
    else
        echo "❌ AVD '$AVD_NAME' não encontrado! Execute a instalação primeiro."
    fi
}

clean_all() {
    echo "⚠️ Isso vai remover TODO o ambiente em $BASE_DIR (Flutter, Android SDK, AVDs, projetos)."
    read -p "Tem certeza? (y/N): " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$BASE_DIR/flutter" "$BASE_DIR/android-sdk" "$BASE_DIR/.android"
        echo "✅ Ambiente removido de $BASE_DIR"
    else
        echo "ℹ️ Operação cancelada."
    fi
}

# =====================================================================
# MENU
# =====================================================================
echo "===================================="
echo " Flutter Manager - 42 (goinfre/$USER)"
echo "===================================="
echo "1) Criar estrutura de pastas"
echo "2) Instalar SDKs (Flutter + Android)"
echo "3) Iniciar emulador"
echo "4) Excluir tudo do ambiente"
echo "0) Sair"
echo "===================================="

read -p "Escolha uma opção: " opt
case $opt in
    1) create_folders ;;
    2) install_sdks ;;
    3) start_emulator ;;
    4) clean_all ;;
    0) echo "Saindo..." ;;
    *) echo "❌ Opção inválida" ;;
esac

